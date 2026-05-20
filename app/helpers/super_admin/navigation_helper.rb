module SuperAdmin::NavigationHelper
  def settings_open?
    params[:controller].in? %w[super_admin/settings super_admin/app_configs]
  end

  def settings_pages(system_check = nil)
    features = SuperAdmin::FeaturesHelper.available_features.select do |_feature, attrs|
      attrs['config_key'].present? && attrs['enabled']
    end

    # Add general at the beginning
    general_feature = [['general', { 'config_key' => 'general', 'name' => 'General' }]]

    if system_check.present?
      general_feature << system_check
      user = User.first
      return user.fetch_avatar_from_gravatar(general_feature) if user
    end

    general_feature + features.to_a
  end
end
