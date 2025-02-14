require_relative 'content_generator'
require_relative 'error'

module RoughDiary
  class Editor
    class Basic
      include RoughDiary
      
      def initialize(data_holder, content_generator)
        @data_holder = data_holder
        @content_generator = content_generator

        @database_manager.data_holder = @data_holder
        @ask_diary_title_by_system = false
      end

      
      def edit
        raise NotImplementedError
        @content_generator.run
      end

      
      def diary_title
        RoughDiary::Config::DEFAULT_DIARY_TITLE
      end
    end
  end



  class SimpleCli < BasicEditor
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

