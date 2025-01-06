require_relative 'config'
require_relative 'error'
require 'tempfile'


module RoughDiary
  class ContentEditor
    def initialize(data_holder)
      @data_holder = data_holder
      @tempfile = Tempfile.create('diary', mode: 666)
      @tempfile.write data_holder.get(:content)
      @tempfile.close
    end

    
    private def edit_tempfile(editor: RoughDiary::Config::EDITOR)
      raise RoughDiary::InvalidConfigrationError,
        'Please configure editor' unless RoughDiary::DiaryUtils.valid_editor?(editor)

      system("#{editor} #{@tempfile.path}")
    end


    def run
      edit_tempfile
      @tempfile.reopen(@tempfile.path, 'r')
      @data_holder.data_content = @tempfile.read
    end


  end
end
