require 'spec_helper'
require 'ETL/parse_csv_line'

describe ETL::ParseCSVLine do
  PARSE_LINE = ETL::

  let(:input_data) do
    '1,JACKSON,AUSTIN,"1,7,X28,126,129,130,132,151",183.4,150,10/1/2012,Weekday,"(41.87632184, -87.77410482)"'
  end

  subject { described_class.(line: input_data).attributes }

  it do
    is_expected.to eql({
      cta_id: 1,
      on_street: 'JACKSON',
      cross_street: 'AUSTIN',
      routes: ['1','7','X28','126','129','130','132','151'],
      boardings: BigDecimal.new('183.4'),
      alightings: BigDecimal.new('150'),
      month_beginning: Date.new(2012,10,1),
      day_type: 'Weekday',
      location: '(41.87632184, -87.77410482)'
    })
  end

end

