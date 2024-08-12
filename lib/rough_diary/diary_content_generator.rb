require_relative 'config'
require_relative 'error'
require 'tempfile'


module RoughDiary
  class DiaryContentGenerator
    def initialize(savedata_manager)
      @savedata_manager = savedata_manager
      @tempfile = Tempfile.create('diary', mode: 666)
      @tempfile.close
    end

    
    private def valid_editor?(editor)
      # Is editor available on shell?
      if editor.nil? ||
          !system("which #{editor} 2>&1 > /dev/null")
        false
      else
        true
      end
    end


    private def edit_tempfile(editor: RoughDiary::Config::EDITOR)
      raise RoughDiary::InvalidConfigrationError,
        'Please configure editor' unless valid_editor?(editor)

      system("#{editor} #{@tempfile.path}")
    end


    private def ask_diary_title
      puts "Please enter diary title (if none, title will be '#{RoughDiary::Config::DEFAULT_DIARY_TITLE}')"

      print 'Diary title: '
      input_title = gets.chomp

      unless input_title.empty?
        @savedata_manager.title_data = input_title
      end
    end


    def run
      edit_tempfile
      ask_diary_title
      @tempfile.reopen(@tempfile.path, 'r')
      @savedata_manager.content_data = @tempfile.read
    end


  end
end
