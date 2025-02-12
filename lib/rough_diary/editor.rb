module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager)
      @database_manager = database_manager
    end

    
    def edit(diary_id)
      # FIXME
      @database_manager.register
    end
  end
end

