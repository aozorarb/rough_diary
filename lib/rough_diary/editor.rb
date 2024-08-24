require_relative 'diary_content_generator'

module RoughDiary
  class Editor
    include RoughDiary
    
    def initialize(database_manager, follow_diary, data_holder: nil)
      @data_holder = data_holder || DataHolder::Fix.new(follow_diary)
      @database_manager = database_manager
      @content_generator = DiaryContentGenerator.new(@data_holder)

      @database_manager.data_holder = @data_holder
    end

    
    def edit
      @content_generator.run
      @database_manager.register
      true
    end
  end
end

