json.partial! 'api/v1/models/contact_inbox', formats: [:json], resource: @contact_inbox
json.xml_result @xml_result.is_a?(Nokogiri::XML::Document) ? @xml_result.to_xml : @xml_result
