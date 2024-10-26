module RoughDiary
  module DiaryUtils
    module_function

    def tag_collect(normal_data_holder)
      raise ArgumentError, 'enter content before collect tags' if normal_data_holder.get(:content).nil?
      normal_data_holder.get(:content).scan(/#[[:word:]]+/)
    end


    def valid_editor?(editor_name)
      # Is editor available on shell?
      if editor_name.nil? ||
          !system("which #{editor_name} 2>&1 > /dev/null")
        false
      else
        true
      end
    end


  end
end
