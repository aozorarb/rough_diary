require 'diff-lcs'
require_relative 'error'


module RoughDiary
  class DiaryDifferenceTracker
    def initialize(base_diary_holder, diary_fix_holders)
      @base_holder = base_diary_holder
      @fix_holders = diary_fix_holders
    end

    
    def merge(level)
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


    def self.track(original_data_holder, changed_data_holder)
      ret_fix = DataHolder::Fix.new(original_data_holder.get(:id))
      ret_fix.data_edit_diffs = Diff::LCS.diff(original_data_holder.get(:content), changed_data_holder.get(:content))

      ret_fix
    end
  end
end
