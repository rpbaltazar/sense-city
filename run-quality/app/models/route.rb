class Route < ActiveRecord::Base
  set_rgeo_factory_for_column(:centroid, RGeo::Geographic.spherical_factory(:srid => 4326))

  delegate :latitude, to: :centroid, allow_nil: true
  delegate :longitude, to: :centroid, allow_nil: true

  validates :latitude, allow_nil: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, allow_nil: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  has_many :route_points, dependent: :destroy

  def compute_geographic_center
    route_coords_factory = Route.rgeo_factory_for_column(:centroid)

    lat,lon = Geocoder::Calculations.geographic_center route_points_coords
    self.centroid = route_coords_factory.point(lon,lat)
    save
  end

  def polyline
    route_points.sort.reduce([]) do |result, point|
      result << {lat: point.latitude, lng: point.longitude }
    end
  end

  private

  def route_points_coords
    route_points.map{|point| [point.latitude, point.longitude]}
  end


end
