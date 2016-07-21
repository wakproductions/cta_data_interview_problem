class CTARoutesController < ApplicationController

  def index
    @routes = cta_route_list
  end

  private

  def cta_route_list
    CTARoute.all
  end
end
