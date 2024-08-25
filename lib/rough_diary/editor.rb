module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager, follow_diary, data_holder: nil)
      @data_holder = data_holder || DataHolder::Fix.new(follow_diary)
      @database_manager = database_manager

      @database_manager.data_holder = @data_holder
    end

    
    def edit
      collected_diaries = @database_manager.collect_diary_same_id
      @database_manager.register
      true
    end
  end
end

