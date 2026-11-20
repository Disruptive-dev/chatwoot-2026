# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Super Admin navigation', type: :request do
  let(:super_admin) { create(:super_admin) }

  # Singular resources have no index route. Administrate still lists them, and
  # resource_index_route raises UrlGenerationError while rendering the sidebar.
  let(:index_nav_exclusions) do
    %w[
      account_users
      access_tokens
      installation_configs
      dashboard
      devise/sessions
      app_configs
      instance_statuses
      settings
      technical_health
    ]
  end

  def expect_authenticated_sidebar(response)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Super Admin Console')
    expect(response.body).to include('Technical Health')
    expect(response.body).to include(%(href="#{super_admin_technical_health_path}"))
    expect(response.body).not_to include('No route matches')
  end

  describe 'Administrate resources' do
    it 'includes technical_health without an index route' do
      namespace = Administrate::Namespace.new(:super_admin)
      resources = namespace.resources.map(&:resource)
      missing_index = resources - namespace.resources_with_index_route

      expect(resources).to include('technical_health')
      expect(missing_index).to include('technical_health')
      expect(missing_index - index_nav_exclusions).to be_empty
    end
  end

  describe 'authenticated pages' do
    before { sign_in(super_admin, scope: :super_admin) }

    it 'renders the dashboard' do
      get super_admin_root_path

      expect_authenticated_sidebar(response)
      expect(response.body).to include('Admin Dashboard')
    end

    it 'renders accounts' do
      get super_admin_accounts_path

      expect_authenticated_sidebar(response)
      expect(response.body).to include('New account')
    end

    it 'renders users' do
      get super_admin_users_path

      expect_authenticated_sidebar(response)
      expect(response.body).to include('New user')
    end

    it 'renders technical health' do
      get super_admin_technical_health_path

      expect_authenticated_sidebar(response)
      expect(response.body).to include('Technical Health Center')
      expect(response.body).to include('NOC Dashboard')
    end
  end

  describe 'sign-in page' do
    it 'renders without a session' do
      get new_super_admin_session_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Howdy, admin')
    end

    it 'redirects protected pages' do
      get super_admin_accounts_path

      expect(response).to redirect_to(new_super_admin_session_path)
    end
  end
end
