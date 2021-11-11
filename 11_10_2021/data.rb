module SlowRuby
  class Data
    @data = []

    def self.data
      if @data.empty?
        current = DateTime.now.to_date
        1_000.times do
          @data << current
          current = current.next_day
        end
      end

      @data
    end
  end
end
