module RoughDiary
  module DiaryUtils
    module_function

    def tag_collect(data_holder)
      raise ArgumentError, 'enter content before collect tags' if data_holder.content.nil?
      data_holder.content.scan(/#[[:word:]]+/)
    end


    def valid_editor?(editor_name)
      # Is editor available on shell?
      # TODO: editor_name -> command
      if editor_name.nil? ||
          !system("which #{editor_name} 2>&1 > /dev/null")
        false
      else
        true
      end
    end
  
  end
end

