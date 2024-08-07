require_relative 'diary_content_generator'

module RoughDiary
  class Writer
    include RoughDiary
    
    def initialize(database_manager)
      @database_manager = database_manager
      @savedata_manager = SavedataManager.new
      @content_generator = DiaryContentGenerator.new(@savedata_manager)
    end

    
    private def generate_diary_content
      @content_generator.run
    end

    
    private def register_database
      @database_manager.savedata_manager = @savedata_manager
      @database_manager.register
    end

    
    def write
      generate_diary_content
      register_database
    end
  end
end

