class CTAStopRoute < ActiveRecord::Base
  belongs_to :cta_stop
  belongs_to :cta_route
end
