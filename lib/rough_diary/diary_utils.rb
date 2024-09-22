module RoughDiary
  module DiaryUtils
    module_function

    def tag_collect(data_holder)
      raise 'enter content before collect tags' if data_holder.get(:content).nil?
      data_holder.get(:content).scan(/#\w+/)
    end


    def valid_editor?(editor)
      # Is editor available on shell?
      if editor.nil? ||
          !system("which #{editor} 2>&1 > /dev/null")
        false
      else
        true
      end
    end


  end
end
