require 'diff-lcs'

module RoughDiary
  module DiaryUtils
    module_function

    def tag_collect(normal_data_holder)
      raise ArgumentError, 'enter content before collect tags' if normal_data_holder.get(:content).nil?
      normal_data_holder.get(:content).scan(/#[[:word:]]+/)
    end


    def get_latest_diary_by_diary_id(id)
      base_diary, fix_holders = @database_manager.collect_diary_by_id(id) 
      latest_diary = diff_tracker
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


    
    module Difference
      module_function

      def diff_merge(level)
        raise ArgumentError, 'Invalid merge level' unless level.between?(0, @fix_holders.size)
          
        merged_diary = @base_holder.dup
        level.times do |l|
          merged_diary = _merge(merged_diary, @fix_holders[l])
        end

        merged_diary
    end


    def all_merge() merge(@fix_holders.size) end


    private def _merge(base, fix)
      ret = Marshal.load(Marshal.dump(base))
      ret.data_content = Diff::LCS.patch(base.get(:content), fix.get(:edit_diffs))
      ret
    end


    def track(original_data_holder, changed_data_holder)
      ret_fix = DataHolder::Fix.new(original_data_holder.get(:id))
      ret_fix.data_edit_diffs = Diff::LCS.diff(original_data_holder.get(:content), changed_data_holder.get(:content))

      ret_fix
    end
  end
end
