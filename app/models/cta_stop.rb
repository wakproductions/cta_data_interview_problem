class CTAStop < ActiveRecord::Base
  has_many :cta_routes, through: :cta_stop_routes
  has_many :cta_stop_routes
  has_many :monthly_traffic_statistics
end
