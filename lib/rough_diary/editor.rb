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



    class SimpleCli < Base
      def diary_title
        puts "Please enter diary title (if none, title will be '#{Config::DEFAULT_DIARY_TITLE}')"
        print 'Diary title: '
        title = gets.chomp

        title.empty? ? title : Config::DEFAULT_DIARY_TITLE
      end


      def edit(file)
        path = file.path
        if DiaryUtils.valid_editor?(Config::EDITOR)
          `#{Config::EDITOR} #{path}`
        else
          raise InvalidConfigrationError, 'Invalid editor: #{Config::EDITOR}'
        end
      end
    end
  end

end

