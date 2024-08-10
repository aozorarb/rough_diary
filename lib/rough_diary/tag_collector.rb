module RoughDiary
  class TagCollector
    def initialize(savedata_manager)
      @savedata_manager = savedata_manager
    end


    def collect
      @tags = @savedata_manager.get(:content).scan(/#\w+/)
    end

  end
end
