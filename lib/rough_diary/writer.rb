require_relative 'diary_content_generator'

module RoughDiary
  class Writer
    include RoughDiary
    
    def initialize(database_manager)
      @database_manager = database_manager
      @savedata_manager = SavedataManager.new(RoughDiary::Config::SAVEDATA_DIR)
      @content_generator = DiaryContentGenerator.new(@savedata_manager)

      @database_manager.savedata_manager = @savedata_manager
    end

    
    def write
      @content_generator.run
      @savedata_manager.create_savefile_path
      @database_manager.register
      @savedata_manager.save
    end
  end
end

