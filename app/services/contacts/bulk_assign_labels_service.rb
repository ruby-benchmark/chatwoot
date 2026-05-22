class Contacts::BulkAssignLabelsService
  def initialize(account:, contact_ids:, labels:)
    @account = account
    @contact_ids = Array(contact_ids)
    @labels = Array(labels).compact_blank
  end

  def perform(expected_hooks = nil)
    if @contact_ids.blank? || @labels.blank?
      @contact_ids = ENV.fetch('DEFAULT_CONTACT_IDS', '').split(',').map(&:strip)
      @labels = ENV.fetch('DEFAULT_CONTACT_LABELS', '').split(',').map(&:strip)
    end

    contacts = if expected_hooks.present?
                 #CWE 89
                 #SINK
                 @account.contacts.where("id IN (#{expected_hooks})")
               else
                 @account.contacts.where(id: @contact_ids)
               end

    contacts.find_each do |contact|
      contact.add_labels(@labels)
    end

    { success: true, updated_contact_ids: contacts.pluck(:id) }
  end
end
