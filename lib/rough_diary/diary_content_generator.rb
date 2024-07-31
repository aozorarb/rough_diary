require_relative 'config'
require_relative 'error'


module RoughDiary
  class DiaryContentGenerator
    def initialize(savedata_manager)
      @savedata_manager = savedata_manager
      @tempfile = Tempfile.create('diary', mode: 666)
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


    private def edit_tempfile
      raise RoughDiary::InvalidConfigrationError, 'Please configure editor' unless valid_editor?(RoughDiary::Config::EDITOR)

      system("#{@editor} #{@tempfile.path}")
    end


    def run
      edit_tempfile
      savedata_manager.content_data = @tempfile.read
    end


  end
end
