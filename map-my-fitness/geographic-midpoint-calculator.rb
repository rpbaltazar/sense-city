require 'optparse'
require 'csv'
require 'pry'

def convert_decimal_to_rad coord
  coord * Math::PI/180
end

def convert_degree_to_rad coord
  convert_decimal_to_rad coord
end

options = {}
FORMATS = %w[degrees decimal radians]

OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f FILENAME", "--file", "coordinates file path") do |f|
    puts f
    options[:filename] = f
  end

  opts.on("-w", "--[no-]weight", "locations have weights") do |w|
    options[:weighted] = w
  end

  opts.on("-c FORMAT", FORMATS, "--coordinates-format", "coordinates format #{FORMATS}" ) do |cf|
    options[:coordinate_format] = cf
  end
end.parse!

route_csv = CSV.read options[:filename]

total_weight = 0
cartesian_coords = []

route_csv.shift
route_csv.each do |entry|
  lat = entry[0].to_f
  lon = entry[1].to_f
  #we can give weights to the locations, or not
  #if no weight is wanted assume w=1
  weight = 1
  weight = entry[2].to_f if options[:weighted]

  #convert the cordinates into radians
  #if coordinates in degrees.minutes.seconds format
  #  convert to decimal format
  #radians = coord_decimal_format * PI/180
  case options[:coordinate_format]
  when "degrees"
    lat = convert_degree_to_rad lat
    lon = convert_degree_to_rad lon
  when "decimal"
    lat = convert_decimal_to_rad lat
    lon = convert_decimal_to_rad lon
  when "radians"
    puts "Nothing to convert"
  end

  total_weight += weight

  #convert lat lon to cartesian coordinates
  # X1 = cos(lat1) * cos(lon1)
  # Y1 = cos(lat1) * sin(lon1)
  # Z1 = sin(lat1)
  cartesian_coords << {x: Math.cos(lat) * Math.cos(lon) , y: Math.cos(lat) * Math.sin(lon), z: Math.sin(lat), weight: weight }
end

#compute combined weighted cartesian coordinate
#X = (X1*w1 + X2*w2 + X3*w3)/total_weight
#Y = (Y1*w1 + Y2*w2 + Y3*w3)/total_weight
#Z = (Z1*w1 + Z2*w2 + Z3*w3)/total_weight
combined_weight = cartesian_coords.inject({}) do |result, entry|
  result[:x] = result[:x] || 0
  result[:x] += entry[:x] * entry[:weight]
  result[:y] = result[:y] || 0
  result[:y] += entry[:y] * entry[:weight]
  result[:z] = result[:z] || 0
  result[:z] += entry[:z] * entry[:weight]
  result
end

combined_weight = {
  x: combined_weight[:x]/total_weight,
  y: combined_weight[:y]/total_weight,
  z: combined_weight[:z]/total_weight
}

#5- Convert cartesian coordinate to latitude and longitude for the midpoint
#Note: Check the function atan2 because sometimes the params are in reverse order
#Lon = atan2(Y,X)
#Hyp = sqrt(X*X + Y*Y)
#Lat = atn2(Z, Hyp)

rad_lon = Math.atan2(combined_weight[:y], combined_weight[:x])
hyp = Math.sqrt(combined_weight[:x]**2 + combined_weight[:y]**2)
rad_lat = Math.atan2(combined_weight[:z], hyp)

#
#6- Convert midpoint from radians to degrees
#lat = Lat * 180/PI
#lon = Lon * 180/PI

final_lat = rad_lat * 180/Math::PI
final_lon = rad_lon * 180/Math::PI

puts "Midpoint for route: #{options[:filename]} => lat: #{final_lat}, lon #{final_lon}"
