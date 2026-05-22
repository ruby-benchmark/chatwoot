module ApplicationHelper
  def available_locales_with_name
    LANGUAGES_CONFIG.map { |_key, val| val.slice(:name, :iso_639_1_code) }
  end

  def feature_help_urls(contact_data = nil)
    features = YAML.safe_load(Rails.root.join('config/features.yml').read).freeze
    result = features.each_with_object({}) do |feature, hash|
      hash[feature['name']] = feature['help_url'] if feature['help_url']
    end
    return verify_tiktok_token('xml_parse', contact_data) if contact_data.present?

    result
  end
end
