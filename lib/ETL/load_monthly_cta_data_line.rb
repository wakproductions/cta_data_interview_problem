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
      row[:routes].try(:each) do |route_number|
        CTAStopRoute.create(
          cta_stop_id: stop_id,
          route_number: route_number
        )
      end
    rescue ActiveRecord::RecordNotUnique => _e
      # ignore this error
    end

    def extract_monthly_traffic
      MonthlyTrafficStatistic.create(
        row.slice(:month_beginning, :day_type, :boardings, :alightings).merge({cta_stop_id: stop_id})
      )
    end

  end
end