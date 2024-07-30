require_relative 'error'


module RoughDiary
  class DiaryContentGenerator
    def initialize(savedata_manager)
      @savedata_manager = savedata_manager
      @tempfile = Tempfile.create('diary')
    end

    
    private def valid_editor?(editor)
      return false if editor.nil?
      # Is editor available on shell?
      return false if system("which #{editor} 2>&1 > /dev/null")

      true
    end


    private def edit_tempfile
      raise InvalidConfigration unless valid_editor?(RoughDiary::EDITOR)

      `#{@editor} #{@tempfile.path}`
    end


    def run
      edit_tempfile
      puts @tempfile.read
    end


  end
end
