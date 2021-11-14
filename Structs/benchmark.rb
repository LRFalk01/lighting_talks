require 'benchmark/ips'
require 'date'
require 'pry'
# gem install benchmark-ips

BasicStruct = Struct.new(:one, :two)
KeywordStruct = Struct.new(:one, :two, keyword_init: true)

class BasicClass
  attr_accessor :one
  attr_accessor :two

  def initialize(one, two)
    @one = one
    @two = two
  end
end

class KeywordClass
  attr_accessor :one
  attr_accessor :two

  def initialize(**init)
    @one = init[:one]
    @two = init[:two]
  end
end

Benchmark.ips do |x|
  x.report('BasicStruct Init') do
    BasicStruct.new(:one, :two)
  end

  x.report('KeywordStruct Init') do
    KeywordStruct.new(one: :one, two: :two)
  end

  x.report('BasicClass Init') do
    BasicClass.new(:one, :two)
  end

  x.report('KeywordClass Init') do
    KeywordClass.new(one: :one, two: :two)
  end

  x.compare!
end

# Warming up --------------------------------------
# BasicStruct Init   691.304k i/100ms
# KeywordStruct Init   358.804k i/100ms
# BasicClass Init   735.211k i/100ms
# KeywordClass Init   384.722k i/100ms
# Calculating -------------------------------------
# BasicStruct Init      7.014M (± 1.5%) i/s -     35.257M in   5.028095s
# KeywordStruct Init      2.667M (± 9.2%) i/s -     13.276M in   5.010177s
# BasicClass Init      7.254M (± 0.9%) i/s -     36.761M in   5.068229s
# KeywordClass Init      3.687M (±11.1%) i/s -     18.467M in   5.089915s
#
# Comparison:
#   BasicClass Init:  7253743.4 i/s
# BasicStruct Init:  7013502.9 i/s - 1.03x  (± 0.00) slower
# KeywordClass Init:  3687273.6 i/s - 1.97x  (± 0.00) slower
# KeywordStruct Init:  2667356.4 i/s - 2.72x  (± 0.00) slower