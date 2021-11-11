module SlowRuby
  class TimeFilter1
    attr_reader :start, :finish

    def initialize(start, finish)
      @start = start
      @finish = finish
    end

    def to_proc
      proc do |value|
        next false if start && value < start
        next false if finish && value > finish

        true
      end
    end
  end
end
