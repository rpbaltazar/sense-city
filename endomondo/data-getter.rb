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

SAN_FRANCISCO = [
  'ci4yfbbdb000d03zzoq8kjdl0',
  'ci4yhy9yy000f03zznho5nm7c',
  'ci4yyrdqi000j03zz8ylornqd',
  'ci4vy1tfy000m02s7v29jkkx4',
  'ci4lnqzte000002xpokc9d25v',
  'ci4usvy81000302s7whpk8qlp',
  'ci4usvryz000202s7llxjafaf',
  'ci4xcxxgc000n02tci92gpvi6',
  'ci4usss1t000102s7hkg0rpqg',
  'ci4tmxpz8000002w7au38un50',
  'ci4yf50s5000c03zzt4h2tnsq',
  'ci4ut5zu5000402s7g6nihdn0',
]

BANGALORE = [
  'ci53tm6va0001032pzez19tgz',
  'ci4v3czb7000502s7lnln7ztr',
  'ci4yfgz37000e03zzg1a6o6vy',
  'ci59onqz2000103z5f90u4k78',
  'ci4yae86r000903zzsna9zh30',
  'ci4xvuiqf000503zz1bah2he8',
  'ci4xs6uhw000403zz9za2guib',
  'ci541fl410002032pbifg5o7a',
  'ci4zftqww0002032zeskt2yuc',
  'ci4x8lumr000l02tco6291y1u',
]

BOSTON = [
  'ci4x0rtb9000h02tcfa5qov33',
  'ci4ooqbyw0001021o7p4qiedw',
  'ci4xird28000003zzz1soh9fj',
  'ci4ue1845000102w7ni64j7pl',
  'ci4w1npi3000p02s7a43zws7q',
  'ci4vzm23c000o02s76ezwdgxe',
  'ci4x1uh3q000j02tcnehaazvw',
  'ci5a6lluy000303z5d02xla24',
  'ci530o426000003v9a6uxvc2l',
  'ci4rb6392000102wddchkqctq',
  'ci4qaiat7000002wdidwagmmb',
  'ci4vv79v9000k02s7n4avp69i',
  'ci4w3emre000002tcnpko08o3',
]

GENEVA = [
  'ci4lr75ve000c02ypnfy0qt8n',
  'ci4lr75ok000302yp9dowz3rm',
  'ci4lr75sm000902ypns4q30xy',
  'ci4lr75sf000602ypyfkxnua3',
  'ci4lr75sl000802ypo4qrcjda',
  'ci4lr75ob000102yphtjj75f5',
  'ci4lr75o6000002yp6eolj0rm',
  'ci4lr75oi000202ypmtgrudhs',
  'ci4lr75vd000b02ypdlm6qbly',
  'ci4lr75v6000a02ypa256zigk',
  'ci4lr75se000502ypjgleg6kj',
  'ci4lr75wi000e02yp5ek72zcr',
]

RIO_DE_JANEIRO = [
  'ci4vxorfp000l02s7nv4mlefu',
  'ci4vjer3i000e02s7r2cj23gs',
  'ci4vye225000n02s7rxjdfxa1',
  'ci5a2vxxf000203z5tenrtp4g',
  'ci4q0adco000002t9qu491siy',
  'ci4xkmrkk000103zzm94zdsu4',
  'ci4oethyi000302ymejc2wc2j',
  'ci4sn1zfb000102wetn54eux9',
  'ci4symwpg000402wejp5hagiv',
  'ci4wsj9if000c02tcrquen3bl',
  'ci4yf41wg000b03zz1sg9c2yb',
  'ci50huz75000003whywxrn4wx',
  'ci4x6nzle000k02tckylmop2g',
  'ci4q2f9cr000102t9di6kx27u',
]
SHANGHAI = [
  'ci5c3vgzv000003v4deetujpe',
  'ci4vk908n000h02s7pqy6aud3',
  'ci4w9izto000302tcgj9hmy9m',
  'ci4wmzegn000702tcc6dn993o',
  'ci4s0caqw000002wey2s695ph',
  'ci4xdbcwd000o02tcoi729rb7',
  'ci4xrkkxy000203zz2qz5x2qt',
  'ci4z8a9d10001032zk4mh5qow',
  'ci521nmr600020347n4s107yh',
  'ci525hppb00030347n3qo265c',
  'ci527ripa000403471yii8wim',
  'ci4yd6rfl000a03zzycxw5inl',
]

ALL_SENSORS = [
  SHANGHAI,
  SAN_FRANCISCO,
  SINGAPORE,
  GENEVA,
  BOSTON,
  BANGALORE
]

ALL_SENSORS.each do |city|
  city.each do |sensor_id|
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
end
