module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager)
      @database_manager = database_manager
    end

    
    def edit(diary_id)
      diary_id = diary_id
      data_holder = DataHolder::Fix.new(diary_id)
      @database_manager.data_holder = data_holder

      edit_diary, fix_holders = @database_manager.collect_diary_by_id(@diary_id)
      diff_tracker = DiaryDifferenceManager.new(edit_diary, fix_holders)
      latest_diary = diff_tracker.all_merge

      @database_manager.register
      true
    end
  end
end

