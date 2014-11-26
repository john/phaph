class Location < ActiveRecord::Base
  
  # accepts_nested_attributes_for :locatable
  
  # belongs_to :locatable, polymorphic: true
  has_many :presences
  has_many :organizations, through: :presences #, source: :locatable, source_type: 'Organization'
  has_many :users, through: :presences #, source: :locatable, source_type: 'User'
  
  # enum state: { active: 0, inactive: 1 }
  
  after_validation :geocode, if: ->(obj){ obj.name.present? and obj.name_changed? }
  
  geocoded_by :name do |obj, results|
    if geo = results.first
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
      obj.country = geo.country_code
      obj.city = geo.city
      obj.state = geo.state
    else
      # Error - we should throw as geocoding wasn't successful
      # This is not yet done to make sure we don't break legacy code
      # Rails.logger.error( "Warning: geocoding for '#{obj.location}' failed" )
      Rails.logger.error "Geocoding failed."
      return nil
    end
  end
  
end
