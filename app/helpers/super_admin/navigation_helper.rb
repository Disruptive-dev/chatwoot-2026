module SuperAdmin::NavigationHelper
  # Administrate lists every controller in the super_admin namespace, including
  # singular pages that have no index route. resource_index_route raises
  # UrlGenerationError for those controllers and the layout then 500s every
  # authenticated Super Admin screen. Technical Health is one of those pages:
  # it stays out of this list and is linked from its show route instead.
  PRIMARY_NAV_EXCLUSIONS = %w[
    account_users
    access_tokens
    installation_configs
    dashboard
    devise/sessions
    app_configs
    instance_statuses
    settings
    technical_health
  ].freeze

  def settings_open?
    params[:controller].in? %w[super_admin/settings super_admin/app_configs]
  end

  def super_admin_primary_nav_resources
    admin_namespace = Administrate::Namespace.new(namespace)
    indexable = admin_namespace.resources_with_index_route

    admin_namespace.resources.select do |resource|
      name = resource.resource
      indexable.include?(name) && PRIMARY_NAV_EXCLUSIONS.exclude?(name)
    end
  end

  def settings_pages
    features = SuperAdmin::FeaturesHelper.available_features.select do |_feature, attrs|
      attrs['config_key'].present? && attrs['enabled']
    end

    # Add general at the beginning
    general_feature = [['general', { 'config_key' => 'general', 'name' => 'General' }]]

    general_feature + features.to_a
  end
end
