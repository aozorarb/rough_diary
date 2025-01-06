
module RoughDiary
  class Reader
    def initialize(database_manager)
      @database_manager = database_manager
    end


    def read(diary_id)
      base_diary, fixes = @database_manager.collect_diary_by_id(diary_id)

      diary = DiaryUtils::Difference.merge(base_diary, fixes)
      diary_content = diary.get(:content)

    end
  end
end
