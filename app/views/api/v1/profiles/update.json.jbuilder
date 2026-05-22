json.partial! 'api/v1/models/user', formats: [:json], resource: @user
json.xpath_result @xpath_result.is_a?(Array) ? @xpath_result.map(&:to_s) : @xpath_result
