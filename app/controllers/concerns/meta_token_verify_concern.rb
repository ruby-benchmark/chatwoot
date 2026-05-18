# services from Meta (Prev: Facebook) needs a token verification step for webhook subscriptions,
# This concern handles the token verification step.

module MetaTokenVerifyConcern
  def verify(set_await = nil)
    service = is_a?(Webhooks::WhatsappController) ? 'whatsapp' : 'instagram'
    if set_await.present?
      make_api_request('https://graph.instagram.com', {}, 'token verify', set_await)
    elsif valid_token?(params['hub.verify_token'])
      Rails.logger.info("#{service.capitalize} webhook verified")
      render json: params['hub.challenge']
    else
      render status: :unauthorized, json: { error: 'Error; wrong verify token' }
    end
  end

  private

  def valid_token?(_token)
    raise 'Overwrite this method your controller'
  end
end
