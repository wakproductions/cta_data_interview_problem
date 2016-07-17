Civis Technical Interview Problem
---------------------------------

Please load the data from https://data.cityofchicago.org/Transportation/CTA-Ridership-Avg-Weekday-Bus-Stop-Boardings-in-Oc/mq3i-nnqe, into a SQL database of your choosing, generate aggregates, and visualize the data (map, chart, or table). We’ll go over what you create in our hangout.

You’re encouraged to use any tools at your disposal and at a minimum, we’ll want to ask how to find the longest bus route by number of stops, and the bus stop that appears on the most bus routes. Be prepared to talk about how you would deploy the results of your analysis as a web application.

## Overview

To get the city of Chicago data into the Postgresql database, I created a Ruby on Rails program to help interpret the
CSV formatted raw data and normalize it. Data was loaded into the database using the following code:

```
require 'ETL/load_monthly_cta_data_line'
require 'ETL/parse_csv_line'

file = File.join(Dir.pwd, 'vendor', 'CTA_-_Ridership_-_Avg._Weekday_Bus_Stop_Boardings_in_October_2012.csv')
f = File.open(file, 'r')
f.readline # clean out the header row
lines = f.read.split("\n")
lines.each { |line| ETL::LoadMonthlyCTADataLine.(row: ETL::ParseCSVLine.(line: line)) }
f.close
```

## Initial Questions

###Longest bus route by number of stops:

```
select count(route_number), route_number from cta_stop_routes
group by route_number
order by count(route_number) desc
```
\#9 bus has the highest number with 273 stops
Next highest is #49 with 242 stops

All the routes serviced by bus #9 can be found by this query:

```
select route_number, cta_id, on_street, cross_street
from cta_stop_routes
inner join cta_stops on cta_stop_routes.cta_stop_id=cta_stops.id
where route_number='9'
```

###Stop that appears on the most routes:

```
select cta_stop_id, cta_id, on_street, cross_street, count(route_number) as route_count
from cta_stop_routes
inner join cta_stops on cta_stop_routes.cta_stop_id=cta_stops.id
group by cta_stop_id, cta_id, on_street, cross_street
order by route_count desc
```

Stop #1106 Michigan & Washington appears on the most number of routes with 14 routes


# Other Observations

I noticed that there were two stops where there "route" column was blank. Stop #9267 Keeler & Belmont is actually
serviced by the #77 bus, and Stop #12548 Addison & Lake Shore is serviced by the 152 bus. My guess is that the source
data is dirty by a system error on the CTA side.


