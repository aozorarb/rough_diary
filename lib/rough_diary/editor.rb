module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager)
      @database_manager = database_manager
    end

    
    def edit(diary_id)
      edit_diary, fix_holders = @database_manager.collect_diary_by_id(diary_id)
      latest_diary = DiaryUtils::Difference.merge(edit_diary, fix_holders)
      org_diary = latest_diary.dup
      editor = ContentEditor.new(latest_diary)
      editor.run

      diff_fix = DiaryUtils::Difference.get(org_diary, latest_diary)
      @database_manager.data_holder = diff_fix

      @database_manager.register
    end
  end
end

