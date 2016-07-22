class CTARoutesController < ApplicationController

  def index
    @routes = cta_route_list
  end

  def show
    @route = CTARoute.find(params[:id])
  end

  private

  def cta_route_list
    CTARoute
      .all
      .includes(:cta_stops)
      .map do |route|
        { id: route.id, name: route.name, stop_count: route.cta_stops.count }
      end
      .sort do |a, b|
        b[:stop_count] <=> a[:stop_count]
      end
  end

end
