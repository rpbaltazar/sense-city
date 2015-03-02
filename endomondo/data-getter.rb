#
#https://localdata-sensors.herokuapp.com/api/sources/ci4wq5cf6000a02tci6u38edj/entries?startIndex=0&count=1

require "net/https"
require "uri"
require "json"
require "csv"

BASE_URL = "https://localdata-sensors.herokuapp.com/api/sources"
REQUEST = "entries"

SINGAPORE = [
  "ci4v5vrcu000602s7g2cur4b2",
  "ci4y9ght2000803zzrj61j1nl",
  "ci599v4yf000003z5b4ovspob",
  "ci4v67rh8000902s7vcxxq6wt",
  "ci4y4ohu3000703zzy0fxkd5n",
  "ci4vejnju000b02s70yzzonp9",
  "ci5lssf4x000003x8j2karv47",
  "ci4wyckhv000f02tcyojovuvr",
  "ci4wq5cf6000a02tci6u38edj",
  "ci52039km00010347y1k3z1u4",
  "ci4wg4xti000502tccs34dvk4",
  "ci4w8gd6f000102tcnp415mz5",
  "ci516u6u8000203wht0ml6o9c",
  "ci4v5wwl4000702s7t1u7rz4a"
]


SINGAPORE.each do |sensor_id|
  uri = URI.parse "#{BASE_URL}/#{sensor_id}/#{REQUEST}?startIndex=0&count=1&sort=desc"
  http = Net::HTTP.new uri.host, uri.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new uri.request_uri

  response = http.request request
  sensor_reading = JSON.parse response.body
  lon,lat = sensor_reading["data"][0]["data"]["location"]

  CSV.open("singapore.csv", "a") do |csv|
    csv << [sensor_id, lat, lon]
  end
end
