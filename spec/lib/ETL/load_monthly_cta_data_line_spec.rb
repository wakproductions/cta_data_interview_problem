require 'spec_helper'
require 'ETL/load_monthly_cta_data_line'
require 'ETL/parse_csv_line'

describe ETL::LoadMonthlyCTADataLine do
  PARSE_LINE = ETL::ParseCSVLine

  let(:input_data) do
    [
      '1,JACKSON,AUSTIN,126,183.4,150,10/1/2012,Weekday,"(41.87632184, -87.77410482)"',

      # same stop, stats from different month
      '1,JACKSON,AUSTIN,126,200,150,11/1/2012,Weekday,"(41.87632184, -87.77410482)"',

      # test that a second stop is entered correctly
      '69,JACKSON,FINANCIAL PLACE,"1,7,X28,126,129,130,132,151",118.4,185.4,10/01/2012,Weekday,"(41.87808100, -87.63286800)"',

      # contains no routes
      '9267,BELMONT,KEELER,,62.4,35.2,10/01/2012,Weekday,"(41.93897000, -87.73212000)"',

      # contains blank route
      '1121,MICHIGAN,E. WACKER,"2,3,,6,10,20,26,N66,151,157",253,571.1,10/01/2012,Weekday,"(41.88807600, -87.62442500)"'
    ]
  end

  before do
    input_data.each do |raw_line|
      described_class.(row: PARSE_LINE.(line: raw_line))
    end
  end

  let(:jackson_austin_stop) do
    CTAStop
      .where('cta_id=? AND on_street=? AND cross_street=? AND location ~= point ?',
             1, 'JACKSON', 'AUSTIN', '(41.87632184, -87.77410482)').first
  end

  let(:jackson_austin_traffic_oct) do
    MonthlyTrafficStatistic.find_by(
      cta_stop_id: jackson_austin_stop.id,
      month_beginning: Date.new(2012,10,1),
      day_type: 'Weekday',
      boardings: BigDecimal.new('183.4'),
      alightings: BigDecimal.new('150')
    )
  end

  let(:jackson_austin_traffic_nov) do
    MonthlyTrafficStatistic.find_by(
      cta_stop_id: jackson_austin_stop.id,
      month_beginning: Date.new(2012,11,1),
      day_type: 'Weekday',
      boardings: BigDecimal.new('200'),
      alightings: BigDecimal.new('150')
    )
  end

  let(:jackson_financial_place_stop) do
    CTAStop
      .where('cta_id=? AND on_street=? AND cross_street=? AND location ~= point ?',
             69, 'JACKSON', 'FINANCIAL PLACE', '(41.87808100, -87.63286800)').first
  end

  let(:jackson_financial_place_traffic) do
    MonthlyTrafficStatistic.find_by(
      cta_stop_id: jackson_financial_place_stop.id,
      month_beginning: Date.new(2012,10,1),
      day_type: 'Weekday',
      boardings: BigDecimal.new('118.4'),
      alightings: BigDecimal.new('185.4')
    )
  end

  let(:belmont_keeler_stop) do
    CTAStop
      .where('cta_id=? AND on_street=? AND cross_street=? AND location ~= point ?',
             9267, 'BELMONT', 'KEELER', '(41.93897000, -87.73212000)').first
  end

  let(:belmont_keeler_traffic) do
    MonthlyTrafficStatistic.find_by(
      cta_stop_id: jackson_financial_place_stop.id,
      month_beginning: Date.new(2012,10,1),
      day_type: 'Weekday',
      boardings: BigDecimal.new('62.4'),
      alightings: BigDecimal.new('35.2')
    )
  end

  let(:michigan_wacker_stop) do
    CTAStop
      .where('cta_id=? AND on_street=? AND cross_street=? AND location ~= point ?',
             1121, 'MICHIGAN', 'E. WACKER', '(41.88807600, -87.62442500)').first
  end

  # Checking by stop - stop has many routes
  let(:jackson_austin_routes) do
    jackson_austin_stop.cta_routes.pluck(:name).sort
  end

  let(:jackson_financial_place_routes) do
    jackson_financial_place_stop.cta_routes.pluck(:name).sort
  end

  let(:belmont_keeler_routes) do
    belmont_keeler_stop.cta_routes # cta_routes should be nil
  end

  let(:michigan_wacker_routes) do
    michigan_wacker_stop.cta_routes.pluck(:name).sort
  end

  it 'correctly loads the data' do
    expect(CTAStop.count).to eql(4)
    expect(CTAStopRoute.count).to eql(18)
    expect(CTARoute.count).to eql(16)
    expect(MonthlyTrafficStatistic.count).to eql(5)

    expect(jackson_austin_stop).to be_present
    expect(jackson_financial_place_stop).to be_present
    expect(belmont_keeler_stop).to be_present

    expect(jackson_austin_traffic_oct).to be_present
    expect(jackson_austin_traffic_nov).to be_present
    expect(jackson_financial_place_traffic).to be_present

    expect(jackson_austin_routes).to eql(['126'])
    expect(jackson_financial_place_routes).to eql("1,126,129,130,132,151,7,X28".split(',').sort)
    expect(michigan_wacker_routes).to eql("2,3,6,10,20,26,151,157,N66".split(',').sort)
    expect(belmont_keeler_routes).to be_empty
  end

end

