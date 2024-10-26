# frozen_string_literal: true

require "test_helper"

include RoughDiary

class DiaryUtils::Test < Minitest::Test
  include DiaryUtils

  def test_tag_collect
    mock_nil_data_holder = Minitest::Mock.new
    mock_nil_data_holder.expect :get, nil, [:content]

    assert_raises(ArgumentError) { tag_collect(mock_nil_data_holder) }

    mock_data_holder = Minitest::Mock.new
    msg = '#hello #世界'
    mock_data_holder.expect :get, msg, [:content]
    mock_data_holder.expect :get, msg, [:content]

    assert_equal ['#hello', '#世界'], tag_collect(mock_data_holder)

    mock_nil_data_holder.verify
    mock_data_holder.verify
  end


  def test_valid_editor?
    assert valid_editor?('sed')
    refute valid_editor?('invalid_editor')
  end

end
