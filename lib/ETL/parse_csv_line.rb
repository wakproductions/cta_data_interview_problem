require 'csv'

module ETL
  class ParseCSVLine
    include Actionizer

    def call
      raw_attributes = CSV.parse(line).first
      output.attributes = {
        cta_id: raw_attributes[0].to_i,
        on_street: raw_attributes[1],
        cross_street: raw_attributes[2],
        routes: raw_attributes[3]&.split(','),
        boardings: BigDecimal.new(raw_attributes[4]),
        alightings: BigDecimal.new(raw_attributes[5]),
        month_beginning: Date.strptime(raw_attributes[6], '%m/%d/%Y'),
        day_type: raw_attributes[7],
        location: raw_attributes[8],
      }
    end

    private

    def line
      @line ||= input.line
    end

  end
end