class Sensor < ActiveRecord::Base
  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  delegate :latitude, :to => :coordinates, :allow_nil => true
  delegate :longitude, :to => :coordinates, :allow_nil => true

  validates :latitude, :presence => true, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :longitude, :presence => true, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
end
