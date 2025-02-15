class SimpleCli
  class Editor < RoughDiary::Editor::Base
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
