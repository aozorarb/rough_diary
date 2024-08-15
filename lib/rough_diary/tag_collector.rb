module RoughDiary
  class TagCollector
    def initialize(data_holder)
      @data_holder = data_holder
    end


    def collect
      @tags = @data_holder.get(:content).scan(/#\w+/)
    end

  end
end
