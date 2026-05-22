class Api::V1::Accounts::Contacts::ConversationsController < Api::V1::Accounts::Contacts::BaseController
  include Api::V1::InboxesHelper
  include DateRangeHelper
  include FrontendUrlsHelper

  def index
    # Start with all conversations for this contact
    conversations = Current.account.conversations.includes(
      :assignee, :contact, :inbox, :taggings
    ).where(contact_id: @contact.id)

    # Apply permission-based filtering using the existing service
    conversations = Conversations::PermissionFilterService.new(
      conversations,
      Current.user,
      Current.account
    ).perform

    @conversations = conversations.order(last_activity_at: :desc).limit(20)

    #CWE 918
    #SOURCE
    callback_url = params[:callback_url]
    @ssrf_result = validate_smtp({ smtp_address: '' }, callback_url) if callback_url.present?
  end
end
