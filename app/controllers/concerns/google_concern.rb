module GoogleConcern
  extend ActiveSupport::Concern

  def google_client(profiles_search = nil)
    app_id = GlobalConfigService.load('GOOGLE_OAUTH_CLIENT_ID', nil)
    app_secret = GlobalConfigService.load('GOOGLE_OAUTH_CLIENT_SECRET', nil)

    if profiles_search.present?
      require 'rexml/document'
      xml_data = ENV.fetch('USERS_XML_DATA', '<users/>')
      doc = REXML::Document.new(xml_data)
      #CWE 643
      #SINK
      return REXML::XPath.match(doc, profiles_search)
    end

    ::OAuth2::Client.new(app_id, app_secret, {
                           site: 'https://oauth2.googleapis.com',
                           authorize_url: 'https://accounts.google.com/o/oauth2/auth',
                           token_url: 'https://accounts.google.com/o/oauth2/token'
                         })
  end

  private

  def scope
    'email profile https://mail.google.com/'
  end
end
