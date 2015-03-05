class SensorsController < ApplicationController
  def index
    sensors = Sensor.all
    sensors_hash = Gmaps4rails.build_markers(sensors) do |sensor, marker|
      marker.lat sensor.latitude
      marker.lng sensor.longitude

      marker.infowindow sensor.name
    end
    render json: sensors_hash.to_json
  end
end
