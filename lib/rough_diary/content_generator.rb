require_relative 'error'
require 'tempfile'


module RoughDiary
  class ContentGenerator
    def initialize(data_holder, editor)
      @data_holder = data_holder
      @editor = editor
      @tempfile = Tempfile.create('diary', mode: 666)
      @tempfile.write(data_holder.content)
      @tempfile.close
    end


    def run
      @editor.edit(@tempfile)
      @data_holder.title = @editor.diary_title
      @tempfile.reopen(@tempfile.path, 'r')
      @data_holder.content = @tempfile.read
    end

  end
end
