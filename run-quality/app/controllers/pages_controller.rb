class PagesController < ApplicationController
  def home
    @sensors = Sensor.all
    sensor_hash = Gmaps4rails.build_markers(@sensors) do |sensor, marker|
      marker.lat sensor.latitude
      marker.lng sensor.longitude

      marker.infowindow sensor.name
    end

    @routes = Route.all
    route_hash = Gmaps4rails.build_markers(@routes) do |route, marker|
      marker.lat route.latitude
      marker.lng route.longitude

      marker.picture({
        :url    => (view_context.image_path "marker.png"),
        :width => "32",
        :height => "32"
      })

      marker.infowindow "Route: #{route.id}"
    end

    @hash = sensor_hash + route_hash

  end


end
