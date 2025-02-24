module SimpleUi
  class Editor < RoughDiary::Editor::Base
    def diary_title
      puts "Please enter diary title (if none, title will be #{configatron.system.default_diary_title})"
      print 'Diary title: '
      title = gets.chomp

      title.empty? ? configatron.system.default_diary_title : title 
    end


    def edit(file)
      path = file.path
      if RoughDiary::DiaryUtils.valid_editor?(configatron.simple_ui.editor)
        system("#{configatron.simple_ui.editor} #{path}")
      else
        raise RoughDiary::InvalidConfigrationError, "Invalid editor: #{configatron.simple_ui.editor}"
      end
    end
  end
end
