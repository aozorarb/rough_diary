module RoughDiary
  class TagCollector
    def initialize(savedata_manager)
      @savedata_manager = savedata_manager
    end


    def collect
      @tags = []
      File.foreach(@savedata_manager.get(:file_path)) do |line|
        @tags << line.scan(/#\w+/)
      end
      @tags
    end

  end
end
