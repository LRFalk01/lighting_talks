require 'benchmark/ips'
require 'date'
require 'pry'
# gem install benchmark-ips

module One
  class DTO
    attr_accessor :item

    def initialize(item)
      @item = item
    end

    def get
      1_000_000.times do
        next @item
      end
    end
  end
end

module Two
  class DTO
    attr_accessor :item

    def initialize(item)
      @item = item
    end

    def get
      1_000_000.times do
        next item
      end
    end
  end
end

Benchmark.ips do |benchmark|
  one = ::One::DTO.new(1)
  two = ::Two::DTO.new(2)

  benchmark.report("ivar") do
    one.get
  end

  benchmark.report("attr") do
    two.get
  end

  benchmark.compare!
end


# Warming up --------------------------------------
# ivar     3.000  i/100ms
# attr     2.000  i/100ms
# Calculating -------------------------------------
# ivar     30.312  (± 3.3%) i/s -    153.000  in   5.056710s
# attr     23.813  (± 4.2%) i/s -    120.000  in   5.057554s
#
# Comparison:
#   ivar:       30.3 i/s
# attr:       23.8 i/s - 1.27x  (± 0.00) slower
#
# ~6 vs ~8 nanoseconds
