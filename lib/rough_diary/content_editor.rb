require_relative 'config'
require_relative 'error'
require 'tempfile'


module RoughDiary
  class ContentEditor
    def initialize(data_holder)
      @data_holder = data_holder
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


    def run
      edit_tempfile
      @tempfile.reopen(@tempfile.path, 'r')
      @data_holder.data_content = @tempfile.read
    end


  end
end
