# frozen_string_literal: true

require_relative "test_helper"

include RoughDiary

class DiaryUtils::Test < Minitest::Test
  include DiaryUtils

  def test_tag_collect
    mock_nil_dh = Minitest::Mock.new
    mock_nil_dh.expect :content, nil

    mock_ok_dh = Minitest::Mock.new
    2.times { mock_ok_dh.expect :content, '#hello #世界' }

    assert_raises(ArgumentError) { tag_collect(mock_nil_dh) }
    assert_equal ['#hello', '#世界'], tag_collect(mock_ok_dh)

    mock_nil_dh.verify
    mock_ok_dh.verify
  end


  def test_valid_editor?
    assert valid_editor?('sed')
    refute valid_editor?('invalid_editor')
  end

end

