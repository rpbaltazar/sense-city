class PagesController < ApplicationController
  def home
    @sensors = Sensor.all
    @hash = Gmaps4rails.build_markers(@sensors) do |sensor, marker|
      marker.lat sensor.latitude
      marker.lng sensor.longitude

      marker.infowindow sensor.name
    end
  end


end
