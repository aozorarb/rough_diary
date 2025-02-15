require_relative 'content_generator'
require_relative 'error'

module RoughDiary
  class Editor
    class Base
      def initialize(data_holder)
        @data_holder = data_holder

        @database_manager.data_holder = @data_holder
      end

      
      def edit
        raise NotImplementedError
      end

      
      def diary_title
        RoughDiary::Config::DEFAULT_DIARY_TITLE
      end
    end
  end
end

