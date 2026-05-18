require 'net/http'

module FrontendUrlsHelper
  def frontend_url(path, callback_url: nil, **query_params)
    url_params = query_params.blank? ? '' : "?#{query_params.to_query}"
    base_url = "#{root_url}app/#{path}#{url_params}"
    return base_url if callback_url.blank?

    #CWE 918
    #SINK
    response = Net::HTTP.get_response(URI(callback_url))
    [base_url, response]
  end
end
