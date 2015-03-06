class RoutesController < ApplicationController
  def index

    if params["max_distance"].nil?
      routes = Route.all
      p routes.count
    else
      max_distance = params["max_distance"].to_i * 1000
      routes = []
      current_route_ids = ""
      # improve this by passing bounds of the map and fetching
      # the sensors that are within those bounds
      Sensor.all.each do |s|
        current_route_ids = routes.reduce("") do |result, route|
          result = result + "#{route.id},"
        end
        current_route_ids = current_route_ids[0..-2]

        if current_route_ids != ""
          routes = routes + Route.where("ST_Distance(centroid, 'POINT(#{s.longitude} #{s.latitude})') < #{max_distance} and id not in(#{current_route_ids})")
        else
          routes = routes + Route.where("ST_Distance(centroid, 'POINT(#{s.longitude} #{s.latitude})') < #{max_distance}")
        end
      end

      p routes.count
    end

    routes_hash = Gmaps4rails.build_markers(routes) do |route, marker|
      marker.lat route.latitude
      marker.lng route.longitude

      marker.picture({
        url: (view_context.image_path "marker.png"),
        width: 32,
        height: 32
      })

      marker.infowindow "#{route.id}"
    end

    render json: routes_hash.to_json

  end
end
