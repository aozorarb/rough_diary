module RoughDiary
  module DiaryHandle
    module_function

    def tag_collect(data_holder)
      raise 'enter content before collect tags' if data_holder.get(:content).nil?
      data_holder.get(:content).scan(/#\w+/)
    end


  end
end
