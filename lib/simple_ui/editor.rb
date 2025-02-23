module SimpleUi
  class Editor < RoughDiary::Editor::Base
    def diary_title
      puts "Please enter diary title (if none, title will be #{configatron.system.diary_default_title})"
      print 'Diary title: '
      title = gets.chomp

      title.empty? ? title : configatron.system.diary_default_title
    end


    def edit(file)
      path = file.path
      if DiaryUtils.valid_editor?(configatron.simple_ui.editor)
        system("#{configatron.simple_ui.editor} #{path}")
      else
        raise InvalidConfigrationError, "Invalid editor: #{configatron.simple_ui.editor}"
      end
    end
  end
end
