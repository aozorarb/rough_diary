# frozen_string_literal: true

require 'test_helper'
require 'diff/lcs'

include RoughDiary

class DiaryDifferenceTracker::Test < Minitest::Test
  def setup
    @base_holder = DataHolder::Normal.new
    @base_holder.data_content = 'hello'
    @base_holder.data_title = 'test'
    @base_holder.data_id = 0

    @fix_holder1 = DataHolder::Fix.new(0)
    @fix_holder1.data_id = 0
    @fix_holder1.data_edit_diffs = Diff::LCS.diff(@base_holder.get(:content), 'hello1')

    merged1 = Diff::LCS.patch(@base_holder.get(:content), @fix_holder1.get(:edit_diffs))
    @fix_holder2 = DataHolder::Fix.new(0)
    @fix_holder2.data_id = 1
    @fix_holder2.data_edit_diffs = Diff::LCS.diff(merged1, 'hello world')

    @tracker = DiaryDifferenceTracker.new(@base_holder, [@fix_holder1, @fix_holder2])
  end


  def test_merge
    merged1 = @tracker.merge(1)
    assert_equal 'hello1', merged1.get(:content)

    merged2 = @tracker.all_merge
    assert_equal 'hello world', merged2.get(:content)
  end
end
