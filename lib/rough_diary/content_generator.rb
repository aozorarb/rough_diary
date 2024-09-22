require_relative 'config'
require_relative 'error'
require 'tempfile'


module RoughDiary
  class ContentGenerator
    def initialize(data_holder)
      @data_holder = data_holder
      @tempfile = Tempfile.create('diary', mode: 666)
      @tempfile.close
    end

    
    private def edit_tempfile(editor: RoughDiary::Config::EDITOR)
      raise RoughDiary::InvalidConfigrationError,
        'Please configure editor' unless RoughDiary::DiaryUtils.valid_editor?(editor)

      system("#{editor} #{@tempfile.path}")
    end


    private def ask_diary_title
      puts "Please enter diary title (if none, title will be '#{RoughDiary::Config::DEFAULT_DIARY_TITLE}')"

      print 'Diary title: '
      input_title = gets.chomp

      unless input_title.empty?
        @data_holder.data_title = input_title
      end
    end


    def run
      edit_tempfile
      ask_diary_title
      @tempfile.reopen(@tempfile.path, 'r')
      @data_holder.data_content = @tempfile.read
    end


  end
end
