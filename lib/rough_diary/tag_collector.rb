module RoughDiary
  class TagCollector
    def initialize(data_holder)
      @data_holder = data_holder
    end


    def collect
      raise 'enter content before collect tags' if @data_holder.get(:content).nil?

      @tags = @data_holder.get(:content).scan(/#\w+/)
    end

  end
end
