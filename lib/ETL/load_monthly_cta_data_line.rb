module ETL
  class LoadMonthlyCTADataLine
    include Actionizer

    attr_reader :stop_id

    def call
      extract_cta_stop
      extract_route
      extract_monthly_traffic
    end

    private

    def row
      @row ||= input.row.attributes
    end

    def extract_cta_stop
      stop = CTAStop.create(row.slice(:cta_id, :on_street, :cross_street, :location))
      @stop_id = stop.id
    rescue ActiveRecord::RecordNotUnique => _e
      @stop_id = CTAStop
         .where('cta_id=? AND on_street=? AND cross_street=? AND location ~= point ?',
                row[:cta_id], row[:on_street], row[:cross_street], row[:location]).first.id
    end

    def extract_route
      row[:routes].try(:each) do |route_name|
        route = CTARoute.find_or_create_by(route_name: route_name)
        # begin
        # rescue ActiveRecord::RecordNotUnique => _e
        #   route = CTARoute.find_by(route_name: route_name)
        # end

        # The stop should have already been created by call to extract_cta_stop
        # binding.pry
        CTAStopRoute.find_or_create_by(cta_stop_id: stop_id, cta_route_id: route.id)
      end
    end

    def extract_monthly_traffic
      MonthlyTrafficStatistic.create(
        row.slice(:month_beginning, :day_type, :boardings, :alightings).merge({cta_stop_id: stop_id})
      )
    end

  end
end