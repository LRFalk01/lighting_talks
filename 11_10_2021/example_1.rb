require_relative './data'
require_relative './time_filter_1'
require_relative './time_filter_2'
require_relative './time_filter_3'
require_relative './time_filter_4'

require 'benchmark/ips'
require 'date'
require 'pry'
# gem install benchmark-ips


Benchmark.ips do |x|
  # init data
  SlowRuby::Data.data

  now = DateTime.now.to_date
  time_filter_1 = SlowRuby::TimeFilter1.new(now.next_day(30), now.next_day(45)).to_proc
  time_filter_2 = SlowRuby::TimeFilter2.new(now.next_day(30), now.next_day(45)).to_proc
  time_filter_3 = SlowRuby::TimeFilter3.new(now.next_day(30), now.next_day(45)).to_proc
  time_filter_4 = SlowRuby::TimeFilter4.new(now.next_day(30), now.next_day(45)).to_proc

  x.report('TimeFilter1') do
    SlowRuby::Data.data.filter { |x| time_filter_1.call(x) }.size
  end

  x.report('TimeFilter2') do
    SlowRuby::Data.data.filter { |x| time_filter_2.call(x) }.size
  end

  x.report('TimeFilter3') do
    SlowRuby::Data.data.filter { |x| time_filter_3.call(x) }.size
  end

  x.report('TimeFilter4') do
    SlowRuby::Data.data.filter { |x| time_filter_4.call(x) }.size
  end

  x.compare!
end

# Warming up --------------------------------------
# TimeFilter1   369.000  i/100ms
# TimeFilter2   373.000  i/100ms
# TimeFilter3   356.000  i/100ms
# TimeFilter4   427.000  i/100ms
# Calculating -------------------------------------
# TimeFilter1      3.180k (±16.9%) i/s -     15.498k in   5.028071s
# TimeFilter2      3.601k (±11.9%) i/s -     17.904k in   5.066283s
# TimeFilter3      3.962k (± 9.6%) i/s -     19.580k in   5.002629s
# TimeFilter4      4.041k (±11.0%) i/s -     20.069k in   5.043278s
#
# Comparison:
#   TimeFilter4:     4040.5 i/s
# TimeFilter3:     3961.5 i/s - same-ish: difference falls within error
# TimeFilter2:     3601.2 i/s - same-ish: difference falls within error
# TimeFilter1:     3180.0 i/s - same-ish: difference falls within error
