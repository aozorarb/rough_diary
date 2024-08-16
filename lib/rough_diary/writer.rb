require_relative 'diary_content_generator'

module RoughDiary
  class Writer
    include RoughDiary
    
    def initialize(database_manager, data_holder: nil)
      @data_holder = data_holder || DataHolder::Normal.new
      @database_manager = database_manager
      @content_generator = DiaryContentGenerator.new(@data_holder)

      @database_manager.data_holder = @data_holder
    end

    
    def write
      @content_generator.run
      @database_manager.register
      true
    end
  end
end

