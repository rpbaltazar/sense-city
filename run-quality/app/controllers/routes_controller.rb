class RoutesController < ApplicationController
  def index
    routes = Route.all
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
