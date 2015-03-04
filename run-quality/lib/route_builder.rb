require 'csv'

filename = ARGV[0]

route_csv = CSV.read filename
route_csv.shift
route_point_coords_factory = RoutePoint.rgeo_factory_for_column(:coordinates)

ActiveRecord::Base.transaction do
  new_route = Route.create

  route_csv.each do |point|
    lat = point[0].to_f
    lon = point[1].to_f
    new_route.route_points.create route: new_route, coordinates: route_point_coords_factory.point(lon, lat)
  end

  new_route.compute_geographic_center
end
