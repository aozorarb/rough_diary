module RoughDiary
  class TagCollector
    def initialize(stage_manager)
      @stage_manager = stage_manager
    end


    def collect
      @tags = []
      File.foreach(@stage_manager.get(:file_path)) do |line|
        @tags << line.scan(/#\w+/)
      end
      @tags
    end

  end
end
