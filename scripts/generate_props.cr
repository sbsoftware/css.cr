require "http/client"
require "json"

properties_url = "https://raw.githubusercontent.com/mdn/data/refs/heads/main/css/properties.json"

class PropertyDefinition
  include JSON::Serializable

  getter status : String?
end

response = HTTP::Client.get(properties_url)
if response.status_code == 200
  properties = Hash(String, PropertyDefinition).from_json(response.body)

  properties.each do |name, definition|
    next if name.starts_with?("-")
    next unless definition.status == "standard"

    puts "prop #{name.gsub("-", "_")} : String"
  end
else
  puts "Response status: #{response.status_code}"
end
