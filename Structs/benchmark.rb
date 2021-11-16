require 'benchmark/ips'
require 'date'
require 'pry'
# gem install benchmark-ips

BasicStruct = Struct.new(:one, :two)
BasicLargeStruct = Struct.new(:one, :two, :three, :four, :five)
KeywordStruct = Struct.new(:one, :two, keyword_init: true)
KeywordLargeStruct = Struct.new(:one, :two, :three, :four, :five, keyword_init: true)

class BasicClass
  attr_accessor :one
  attr_accessor :two

  def initialize(one, two)
    @one = one
    @two = two
  end
end

class BasicLargeClass
  attr_accessor :one, :two, :three, :four, :five

  def initialize(one = nil, two = nil, three = nil, four = nil, five = nil)
    @one = one
    @two = two
    @three = three
    @four = four
    @five = five
  end
end

class KeywordClass
  attr_accessor :one
  attr_accessor :two

  def initialize(one:, two:)
    @one = one
    @two = two
  end
end

class KeywordLargeClass
  attr_accessor :one, :two, :three, :four, :five

  def initialize(one:, two: nil, three: nil, four: nil, five: nil)
    @one = one
    @two = two
    @three = three
    @four = four
    @five = five
  end
end

pp 'Two property objects'
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

pp 'Five property objects'
Benchmark.ips do |x|
  x.report('BasicStruct Init') do
    BasicLargeStruct.new(:one, :two, :three, :four, :five)
  end

  x.report('KeywordStruct Init') do
    KeywordLargeStruct.new(one: :one, two: :two, three: :three, four: :four, five: :five)
  end

  x.report('BasicClass Init') do
    BasicLargeClass.new(:one, :two, :three, :four, :five)
  end

  x.report('KeywordClass Init') do
    KeywordLargeClass.new(one: :one, two: :two, three: :three, four: :four, five: :five)
  end

  x.compare!
end

pp 'Kwargs arity'
Benchmark.ips do |x|
  x.report('Keyword One Init') do
    KeywordLargeStruct.new(one: :one)
  end

  x.report('Keyword Two Init') do
    KeywordLargeStruct.new(one: :one, two: :two)
  end

  x.report('Keyword Three Init') do
    KeywordLargeStruct.new(one: :one, two: :two, three: :tree)
  end

  x.report('Keyword Four Init') do
    KeywordLargeStruct.new(one: :one, two: :two, three: :tree, four: :four)
  end

  x.report('Keyword Five Init') do
    KeywordLargeStruct.new(one: :one, two: :two, three: :tree, four: :four, five: :five)
  end

  x.compare!
end

pp 'Positional arity'
Benchmark.ips do |x|
  x.report('Positional One Init') do
    BasicLargeStruct.new(:one)
  end

  x.report('Positional Two Init') do
    BasicLargeStruct.new(:one, :two)
  end

  x.report('Positional Three Init') do
    BasicLargeStruct.new(:one, :two, :tree)
  end

  x.report('Positional Four Init') do
    BasicLargeStruct.new(:one, :two, :tree, :four)
  end

  x.report('Positional Five Init') do
    BasicLargeStruct.new(:one, :two, :tree, :four, :five)
  end

  x.compare!
end

# "Two property objects"
# Warming up --------------------------------------
# BasicStruct Init   681.488k i/100ms
# KeywordStruct Init   325.082k i/100ms
# BasicClass Init   734.466k i/100ms
# KeywordClass Init   379.869k i/100ms
# Calculating -------------------------------------
# BasicStruct Init      6.774M (± 3.2%) i/s -     34.074M in   5.036251s
# KeywordStruct Init      3.374M (± 1.6%) i/s -     16.904M in   5.011279s
# BasicClass Init      7.457M (± 1.5%) i/s -     37.458M in   5.024486s
# KeywordClass Init      3.712M (± 1.2%) i/s -     18.614M in   5.014527s
#
# Comparison:
#   BasicClass Init:  7456834.3 i/s
# BasicStruct Init:  6773693.0 i/s - 1.10x  (± 0.00) slower
# KeywordClass Init:  3712433.7 i/s - 2.01x  (± 0.00) slower
# KeywordStruct Init:  3374102.7 i/s - 2.21x  (± 0.00) slower
#
# "Five property objects"
# Warming up --------------------------------------
# BasicStruct Init   627.380k i/100ms
# KeywordStruct Init   220.763k i/100ms
# BasicClass Init   583.862k i/100ms
# KeywordClass Init   252.575k i/100ms
# Calculating -------------------------------------
# BasicStruct Init      6.195M (± 2.3%) i/s -     31.369M in   5.066562s
# KeywordStruct Init      2.230M (± 2.9%) i/s -     11.259M in   5.052580s
# BasicClass Init      5.749M (± 1.4%) i/s -     29.193M in   5.078847s
# KeywordClass Init      2.543M (± 1.6%) i/s -     12.881M in   5.065867s
#
# Comparison:
#   BasicStruct Init:  6194678.6 i/s
# BasicClass Init:  5749123.1 i/s - 1.08x  (± 0.00) slower
# KeywordClass Init:  2543392.5 i/s - 2.44x  (± 0.00) slower
# KeywordStruct Init:  2230418.5 i/s - 2.78x  (± 0.00) slower
#
# "Kwargs arity"
# Warming up --------------------------------------
# Keyword One Init   392.098k i/100ms
# Keyword Two Init   337.357k i/100ms
# Keyword Three Init   289.390k i/100ms
# Keyword Four Init   251.085k i/100ms
# Keyword Five Init   219.068k i/100ms
# Calculating -------------------------------------
# Keyword One Init      3.876M (± 4.5%) i/s -     19.605M in   5.069992s
# Keyword Two Init      3.223M (± 6.4%) i/s -     16.193M in   5.047331s
# Keyword Three Init      2.846M (± 5.6%) i/s -     14.180M in   5.000291s
# Keyword Four Init      2.458M (± 6.5%) i/s -     12.303M in   5.028668s
# Keyword Five Init      2.226M (± 6.1%) i/s -     11.172M in   5.039555s
#
# Comparison:
#   Keyword One Init:  3875628.7 i/s
# Keyword Two Init:  3222815.0 i/s - 1.20x  (± 0.00) slower
# Keyword Three Init:  2845869.2 i/s - 1.36x  (± 0.00) slower
# Keyword Four Init:  2457856.0 i/s - 1.58x  (± 0.00) slower
# Keyword Five Init:  2226096.1 i/s - 1.74x  (± 0.00) slower
#
# "Positional arity"
# Warming up --------------------------------------
#  Positional One Init   583.862k i/100ms
#  Positional Two Init   575.682k i/100ms
# Positional Three Init
#                        584.673k i/100ms
# Positional Four Init   580.748k i/100ms
# Positional Five Init   595.046k i/100ms
# Calculating -------------------------------------
#  Positional One Init      6.073M (± 2.8%) i/s -     30.361M in   5.003465s
#  Positional Two Init      5.855M (± 3.5%) i/s -     29.360M in   5.021102s
# Positional Three Init
#                           5.723M (± 5.0%) i/s -     28.649M in   5.019322s
# Positional Four Init      5.896M (± 1.8%) i/s -     29.618M in   5.024867s
# Positional Five Init      5.928M (± 2.7%) i/s -     29.752M in   5.022336s
#
# Comparison:
#  Positional One Init:  6072803.0 i/s
# Positional Five Init:  5928492.6 i/s - same-ish: difference falls within error
# Positional Four Init:  5896160.7 i/s - same-ish: difference falls within error
#  Positional Two Init:  5854787.7 i/s - same-ish: difference falls within error
# Positional Three Init:  5722905.5 i/s - same-ish: difference falls within error
