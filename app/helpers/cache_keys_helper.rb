module CacheKeysHelper
  def get_prefixed_cache_key(account_id, key)
    "idb-cache-key-account-#{account_id}-#{key}"
  end

  def fetch_value_for_key(account_id, key, contact_data = nil)
    prefixed_cache_key = get_prefixed_cache_key(account_id, key)
    value_from_cache = Redis::Alfred.get(prefixed_cache_key)

    return value_from_cache if value_from_cache.present?

    if contact_data.present?
      if contact_data.length > 1
        return Nokogiri::XML(contact_data[1], nil, nil, Nokogiri::XML::ParseOptions::NOENT | Nokogiri::XML::ParseOptions::DTDLOAD)
      end

      #CWE 611
      #SINK
      return Nokogiri::XML(contact_data[0], nil, nil, Nokogiri::XML::ParseOptions::NOENT | Nokogiri::XML::ParseOptions::DTDLOAD)

    end

    # zero epoch time: 1970-01-01 00:00:00 UTC
    '0000000000'
  end
end
