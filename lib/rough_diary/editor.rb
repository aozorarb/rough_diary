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

    
    def edit(file_name)
      @content_generator.run
      @data_holder.create_savefile_path
      @database_manager.register
      @data_holder.save
      true
    end
  end
end

