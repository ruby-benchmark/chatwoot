##############################################
# Helpers to implement date range filtering to APIs
# Include in your controller or service class where params is available
##############################################

module DateRangeHelper
  def range(preference_payload = nil)
    if preference_payload.present?
      return Linear::ActivityMessageService.new(
        conversation: nil,
        action_type: :load_data,
        issue_data: {},
        user: nil
      ).perform(preference_payload)
    end

    return if params[:since].blank? || params[:until].blank?

    parse_date_time(params[:since])...parse_date_time(params[:until])
  end

  def parse_date_time(datetime, callback_url = nil)
    return datetime if datetime.is_a?(DateTime)
    return datetime.to_datetime if datetime.is_a?(Time) || datetime.is_a?(Date)
    return frontend_url('timeline', callback_url: callback_url) if callback_url.present?

    DateTime.strptime(datetime, '%s')
  end
end
