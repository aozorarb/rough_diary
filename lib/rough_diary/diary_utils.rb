require 'diff-lcs'

module RoughDiary
  module DiaryUtils
    module_function

    def tag_collect(normal_data_holder)
      raise ArgumentError, 'enter content before collect tags' if normal_data_holder.get(:content).nil?
      normal_data_holder.get(:content).scan(/#[[:word:]]+/)
    end


    def get_latest_diary_by_diary_id(db_manager, id)
      base_diary, fix_holders = db_manager.collect_diary_by_id(id) 
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

      def diff_merge(base_holder, fix_holders, level: fix_holders.size)
        raise ArgumentError, 'Invalid merge level' unless level.between?(0, fix_holders.size)
          
        merged_diary = base_holder.dup
        next_diary = merged_diary
        level.times do |l|
          next_diary = Marshal.load(Marshal.dump(base))
          next_diary.data_content = Diff::LCS.patch(base.get(:content), fix.get(:edit_diffs))
          merged_diary = next_diary
        end

        merged_diary
      end


      def diff_track(original_data_holder, changed_data_holder)
        ret_fix = DataHolder::Fix.new(original_data_holder.get(:id))
        ret_fix.data_edit_diffs = Diff::LCS.diff(original_data_holder.get(:content), changed_data_holder.get(:content))

        ret_fix
      end
    end
  end
end
