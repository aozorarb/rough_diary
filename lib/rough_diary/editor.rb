require_relative 'diary_content_generator'

module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager, savedata: nil)
      @savedata_manager = savedata || SavedataManager.new(RoughDiary::Config::SAVEDATA_DIR, type: :fix)
      @database_manager = database_manager
      @content_generator = DiaryContentGenerator.new(@savedata_manager)

      @database_manager.savedata_manager = @savedata_manager
    end

    
    def edit(file_name)
      @content_generator.run
      @savedata_manager.create_savefile_path
      @database_manager.register
      @savedata_manager.save
      true
    end
  end
end

