require "net/https"
require "uri"
require "json"

BASE_URL = "https://localdata-sensors.herokuapp.com/api/sources"
REQUEST = "entries"

SINGAPORE = [
  {sensor_id: "ci4v5vrcu000602s7g2cur4b2", name: "SECSensor" },
  {sensor_id: "ci4y9ght2000803zzrj61j1nl", name: "HackerspaceSGSeeed" },
  {sensor_id: "ci599v4yf000003z5b4ovspob", name: "Durianz" },
  {sensor_id: "ci4v67rh8000902s7vcxxq6wt", name: "sg_hougang_61" },
  {sensor_id: "ci4y4ohu3000703zzy0fxkd5n", name: "The ThunderBolt" },
  {sensor_id: "ci4vejnju000b02s70yzzonp9", name: "NorthStarOne" },
  {sensor_id: "ci5lssf4x000003x8j2karv47", name: "Aislinnn" },
  {sensor_id: "ci4wyckhv000f02tcyojovuvr", name: "ghimmohyandao" },
  {sensor_id: "ci4wq5cf6000a02tci6u38edj", name: "mm@alexandra" },
  {sensor_id: "ci52039km00010347y1k3z1u4", name: "Gecko" },
  {sensor_id: "ci4wg4xti000502tccs34dvk4", name: "swissnexSG" },
  {sensor_id: "ci4w8gd6f000102tcnp415mz5", name: "HPSG730864" },
  {sensor_id: "ci516u6u8000203wht0ml6o9c", name: "reversehaven" },
  {sensor_id: "ci4v5wwl4000702s7t1u7rz4a", name: "rpbaltazar@bukit-timah" }
]


SAN_FRANCISCO = [
  {sensor_id: 'ci4yfbbdb000d03zzoq8kjdl0', name: "Urban Launchpad"},
  {sensor_id: 'ci4yhy9yy000f03zznho5nm7c', name: "GlenParklifeLogger"},
  {sensor_id: 'ci4yyrdqi000j03zz8ylornqd', name: "ClimateNinja9000"},
  {sensor_id: 'ci4vy1tfy000m02s7v29jkkx4', name: "Exploratorium"},
  {sensor_id: 'ci4lnqzte000002xpokc9d25v', name: "Datavore"},
  {sensor_id: 'ci4usvy81000302s7whpk8qlp', name: "Grand Theater"},
  {sensor_id: 'ci4usvryz000202s7llxjafaf', name: "mapsense"},
  {sensor_id: 'ci4xcxxgc000n02tci92gpvi6', name: "GehlData"},
  {sensor_id: 'ci4usss1t000102s7hkg0rpqg', name: "a-streetcar-named-data-sensor"},
  {sensor_id: 'ci4tmxpz8000002w7au38un50', name: "AlleyCat"},
  {sensor_id: 'ci4yf50s5000c03zzt4h2tnsq', name: "DataDonut"},
  {sensor_id: 'ci4ut5zu5000402s7g6nihdn0', name: "grapealope"}
]


BANGALORE = [
  { sensor_id: 'ci53tm6va0001032pzez19tgz', name: "MODseeed" },
  { sensor_id: 'ci4v3czb7000502s7lnln7ztr', name: "openbangalore" },
  { sensor_id: 'ci4yfgz37000e03zzg1a6o6vy', name: "WRI" },
  { sensor_id: 'ci59onqz2000103z5f90u4k78', name: "Nextdrop" },
  { sensor_id: 'ci4yae86r000903zzsna9zh30', name: "DataBrigade" },
  { sensor_id: 'ci4xvuiqf000503zz1bah2he8', name: "Laddoo" },
  { sensor_id: 'ci4xs6uhw000403zz9za2guib', name: "Palantir" },
  { sensor_id: 'ci541fl410002032pbifg5o7a', name: "Claptrap" },
  { sensor_id: 'ci4zftqww0002032zeskt2yuc', name: "sycsmlp1" },
  { sensor_id: 'ci4x8lumr000l02tco6291y1u', name: "Geekstorm" }
]

BOSTON = [
  { sensor_id: 'ci4x0rtb9000h02tcfa5qov33', name: "soldering defect" },
  { sensor_id: 'ci4ooqbyw0001021o7p4qiedw', name: "Pineapple" },
  { sensor_id: 'ci4xird28000003zzz1soh9fj', name: "Sproutuino" },
  { sensor_id: 'ci4ue1845000102w7ni64j7pl', name: "monalisa" },
  { sensor_id: 'ci4w1npi3000p02s7a43zws7q', name: "SeeedSensor" },
  { sensor_id: 'ci4vzm23c000o02s76ezwdgxe', name: "badgersense" },
  { sensor_id: 'ci4x1uh3q000j02tcnehaazvw', name: "Sparkling" },
  { sensor_id: 'ci5a6lluy000303z5d02xla24', name: "Euclid" },
  { sensor_id: 'ci530o426000003v9a6uxvc2l', name: "firehazard" },
  { sensor_id: 'ci4rb6392000102wddchkqctq', name: "Home1" },
  { sensor_id: 'ci4qaiat7000002wdidwagmmb', name: "theperch" },
  { sensor_id: 'ci4vv79v9000k02s7n4avp69i', name: "Richard" },
  { sensor_id: 'ci4w3emre000002tcnpko08o3', name: "Gabe Sensor" },
]


GENEVA = [
  { sensor_id: 'ci4lr75ve000c02ypnfy0qt8n', name: "Geneva16" },
  { sensor_id: 'ci4lr75ok000302yp9dowz3rm', name: "Geneva6" },
  { sensor_id: 'ci4lr75sm000902ypns4q30xy', name: "Geneva7" },
  { sensor_id: 'ci4lr75sf000602ypyfkxnua3', name: "Laconn'air" },
  { sensor_id: 'ci4lr75sl000802ypo4qrcjda', name: "OpiOneKenopi" },
  { sensor_id: 'ci4lr75ob000102yphtjj75f5', name: "Orion" },
  { sensor_id: 'ci4lr75o6000002yp6eolj0rm', name: "metabolo" },
  { sensor_id: 'ci4lr75oi000202ypmtgrudhs', name: "makegeneve" },
  { sensor_id: 'ci4lr75vd000b02ypdlm6qbly', name: "Geneva11" },
  { sensor_id: 'ci4lr75v6000a02ypa256zigk', name: "LEClife" },
  { sensor_id: 'ci4lr75se000502ypjgleg6kj', name: "Geneva14" },
  { sensor_id: 'ci4lr75wi000e02yp5ek72zcr', name: "Geneva15" }
]


RIO_DE_JANEIRO = [
  { sensor_id: 'ci4vxorfp000l02s7nv4mlefu', name: "Crisp Cookie" },
  { sensor_id: 'ci4vjer3i000e02s7r2cj23gs', name: "Rio40" },
  { sensor_id: 'ci4vye225000n02s7rxjdfxa1', name: "PadulaNiteroiRJ" },
  { sensor_id: 'ci5a2vxxf000203z5tenrtp4g', name: "coppentt" },
  { sensor_id: 'ci4q0adco000002t9qu491siy', name: "BarraDaTijucaCanvas" },
  { sensor_id: 'ci4xkmrkk000103zzm94zdsu4', name: "Kennyduino" },
  { sensor_id: 'ci4oethyi000302ymejc2wc2j', name: "swissnexbrazil" },
  { sensor_id: 'ci4sn1zfb000102wetn54eux9', name: "OurHomeMakerSpace DataCanvas@Rio" },
  { sensor_id: 'ci4symwpg000402wejp5hagiv', name: "BarmaCanvas" },
  { sensor_id: 'ci4wsj9if000c02tcrquen3bl', name: "GaveaDataCanvas" },
  { sensor_id: 'ci4yf41wg000b03zz1sg9c2yb', name: "valeriab" },
  { sensor_id: 'ci50huz75000003whywxrn4wx', name: "Cavalo" },
  { sensor_id: 'ci4x6nzle000k02tckylmop2g', name: "Olabi" },
  { sensor_id: 'ci4q2f9cr000102t9di6kx27u', name: "nico" }
]


SHANGHAI = [
  { sensor_id: 'ci5c3vgzv000003v4deetujpe', name: "james" },
  { sensor_id: 'ci4vk908n000h02s7pqy6aud3', name: "penguin" },
  { sensor_id: 'ci4w9izto000302tcgj9hmy9m', name: "WGQ" },
  { sensor_id: 'ci4wmzegn000702tcc6dn993o', name: "frogsh" },
  { sensor_id: 'ci4s0caqw000002wey2s695ph', name: "fraserxu" },
  { sensor_id: 'ci4xdbcwd000o02tcoi729rb7', name: "SASPudong" },
  { sensor_id: 'ci4xrkkxy000203zz2qz5x2qt', name: "transistor" },
  { sensor_id: 'ci4z8a9d10001032zk4mh5qow', name: "JiadingSensor" },
  { sensor_id: 'ci521nmr600020347n4s107yh', name: "xinchejian" },
  { sensor_id: 'ci525hppb00030347n3qo265c', name: "Simons All Knowing Box" },
  { sensor_id: 'ci527ripa000403471yii8wim', name: "TheMarms" },
  { sensor_id: 'ci4yd6rfl000a03zzycxw5inl', name: "chinotto" }
]

ALL_SENSORS = [
  SHANGHAI,
  SAN_FRANCISCO,
  SINGAPORE,
  GENEVA,
  BOSTON,
  BANGALORE,
  RIO_DE_JANEIRO
]

ALL_SENSORS.each do |city|
  city.each do |sensor|
    sensor_id = sensor[:sensor_id]
    sensor_name = sensor[:name]
    uri = URI.parse "#{BASE_URL}/#{sensor_id}/#{REQUEST}?count=1&sort=desc"
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new uri.request_uri

    response = http.request request
    sensor_reading = JSON.parse response.body
    lon,lat = sensor_reading["data"][0]["data"]["location"]

    sensor_coords_factory = Sensor.rgeo_factory_for_column(:coordinates)
    s = Sensor.create sensor_id: sensor_id, name: sensor_name, coordinates: sensor_coords_factory.point(lon.to_f, lat.to_f)
    puts "Sensor created: #{s.name} @ #{s.coordinates}"
  end
end
