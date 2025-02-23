require_relative 'content_generator'
require_relative 'error'

module RoughDiary
  class Editor
    class Base
      def edit
        raise NotImplementedError
      end

      
      def diary_title
        configatron.system.default_diary_title
      end
    end
  end
end

