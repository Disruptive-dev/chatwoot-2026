# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Super Admin navigation', type: :request do
  let(:super_admin) { create(:super_admin) }

  # Vite asset builds are unrelated to the sidebar 500. Replace the tags so a
  # missing manifest cannot hide the routing failure this spec locks.
  vite_tag_stub = Module.new do
    def vite_client_tag(*)
      ''
    end

    def vite_javascript_tag(*)
      ''
    end
  end

  before do
    # ActionView is already loaded in the request spec, so on_load would not run.
    # rubocop:disable Rails/ActiveSupportOnLoad
    ActionView::Base.prepend(vite_tag_stub) unless vite_tag_stub >= ActionView::Base
    # rubocop:enable Rails/ActiveSupportOnLoad
  end

  def expect_primary_nav_links
    expect(response.body).to include('Super Admin Console')
    expect(response.body).to include('New user')
    expect(response.body).to include(%(href="#{super_admin_users_path}"))
    expect(response.body).to include(%(href="#{super_admin_accounts_path}"))
  end

  def expect_technical_health_link
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(%(href="#{super_admin_technical_health_path}"))
    expect(response.body).not_to include('No route matches')
  end

  def with_indexless_super_admin_resource(controller_name)
    route_set = Rails.application.routes
    route_set.disable_clear_and_finalize = true
    route_set.draw do
      get "/super_admin/#{controller_name}", to: "super_admin/#{controller_name}#show"
    end
    yield
  ensure
    route_set.disable_clear_and_finalize = false
    Rails.application.reload_routes!
  end

  describe 'GET /super_admin/users' do
    it 'redirects anonymous visitors to the super admin sign-in' do
      get super_admin_users_path

      expect(response).to redirect_to(new_super_admin_session_path)
      expect(response).not_to have_http_status(:internal_server_error)
    end

    it 'rejects an agent session instead of rendering the console' do
      sign_in(create(:user), scope: :user)

      get super_admin_users_path

      expect(response).to redirect_to(new_super_admin_session_path)
      expect(response).not_to have_http_status(:internal_server_error)
    end

    context 'when authenticated as a super admin' do
      before { sign_in(super_admin, scope: :super_admin) }

      it 'renders the users page and links Technical Health to its show route' do
        admin_namespace = Administrate::Namespace.new(:super_admin)
        resource_names = admin_namespace.resources.map(&:resource)

        expect(resource_names).to include('technical_health')
        expect(admin_namespace.resources_with_index_route).not_to include('technical_health')

        get super_admin_users_path

        expect_primary_nav_links
        expect_technical_health_link
      end

      it 'still renders when another super admin resource has no index route' do
        with_indexless_super_admin_resource('nav_probe') do
          admin_namespace = Administrate::Namespace.new(:super_admin)
          resource_names = admin_namespace.resources.map(&:resource)

          expect(resource_names).to include('nav_probe')
          expect(admin_namespace.resources_with_index_route).not_to include('nav_probe')

          get super_admin_users_path
        end

        expect_primary_nav_links
        expect_technical_health_link
        expect(response.body).not_to include('Nav Probe')
      end
    end
  end
end
