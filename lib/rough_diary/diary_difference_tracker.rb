require 'diff-lcs'
require_relative 'error'


module RoughDiary
  class DiaryDifferenceTracker
    def initialize(base_diary_holder, diary_fixies_holders)
      @base_holder = base_diary_holder
      @fixies_holders = diary_fixies_holders
    end

    
    def merge(level)
      level ||= @fixies_holders.size

      raise ArgumentError, 'Invalid merge level' unless level.between?(0, @fixies_holders.size)
      
      merged_diary = @base_holder.dup
      level.times do |l|
        merged_diary = _merge(merged_diary, @fixies_holders[l])
      end

      merged_diary
    end


    private def _merge(base, fix)
      ret = base.dup
      ret.data_edit_diffs = Diff::LCS.patch(base.get(:content), fix.get(:edit_diffs))
      ret
    end

    alias_method all_merge merge(nil)


    def self.track(original_data, changed_data)
      ret_fix = DataHolder::Fix.new
      ret_fix.data_id = original_data.get(:id)
      ret_fix.data_edit_diffs = Diff::LCS.diff(original_data, changed_data)

      ret_fix
    end
  end
end
