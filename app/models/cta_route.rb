class CTARoute < ActiveRecord::Base
  has_many :cta_stop_routes
  has_many :cta_stops, through: :cta_stop_routes
end
