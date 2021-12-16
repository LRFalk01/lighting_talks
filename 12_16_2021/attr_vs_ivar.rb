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
      @item
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
      item
    end
  end
end


n = 1_000_000

Benchmark.ips do |benchmark|
  one = ::One::DTO.new(1)
  two = ::Two::DTO.new(2)

  benchmark.report("ivar") do
    (1..n).each do
      one.get
    end
  end

  benchmark.report("attr") do
    (1..n).each do
      two.get
    end
  end

  benchmark.compare!
end


# Warming up --------------------------------------
# ivar     1.000  i/100ms
# attr     1.000  i/100ms
# Calculating -------------------------------------
# ivar     19.265  (± 5.2%) i/s -     97.000  in   5.042461s
# attr     15.795  (± 6.3%) i/s -     79.000  in   5.020245s
#
# Comparison:
#   ivar:       19.3 i/s
# attr:       15.8 i/s - 1.22x  (± 0.00) slower