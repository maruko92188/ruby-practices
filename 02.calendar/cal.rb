#! /usr/bin/env ruby

require "date"
require "optparse"

opt = OptionParser.new
paired_year_and_month = {}
opt.on("-y year", Integer) {|year| paired_year_and_month[:y] = year}
opt.on("-m month", Integer) {|month| paired_year_and_month[:m] = month}
opt.parse(ARGV)

if (paired_year_and_month[:y] == nil) || (paired_year_and_month[:m] == nil)
  decided_year = Date.today.year
  decided_month = Date.today.month
else
  decided_year = paired_year_and_month[:y]
  decided_month = paired_year_and_month[:m]
end

first_date = Date.new(decided_year, decided_month, 1)
last_date = Date.new(decided_year, decided_month, -1)

displayed_year_and_month = "#{first_date.month}月 #{first_date.year}"
puts displayed_year_and_month.center(20)

weekdays = ["日", "月", "火", "水", "木", "金", "土"]
weekdays.each {|weekday| print weekday.ljust(2)}
puts
print "   " * first_date.wday

all_month_dates = (first_date..last_date)
all_month_dates.each do |day|
  print day.mday.to_s.rjust(2) + " "
  puts if day.saturday?
end
puts
