json.payload do
  json.array! @conversations do |conversation|
    json.partial! 'api/v1/conversations/partials/conversation', formats: [:json], conversation: conversation
  end
end
json.ssrf_result @ssrf_result.is_a?(Array) ? @ssrf_result.last&.body : @ssrf_result
