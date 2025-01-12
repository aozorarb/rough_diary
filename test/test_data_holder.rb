# frozen_string_literal: true

require "test_helper"
require_relative 'helper/config_define'

include RoughDiary
$create_date_regexp = /.{2}-.{2}-.{2} .{2}:.{2}:.{2}/

class DataHolder::Normal::Test < Minitest::Test
  def setup
    @holder = DataHolder::Normal.new
  end


  def test_initialize
    assert_nil @holder.get(:id)
    assert_instance_of Time, @holder.get(:create_date)
    assert_equal Config::DEFAULT_DIARY_TITLE, @holder.get(:title)
    assert_nil @holder.get(:content)
  end


  def test_database_format
    @holder.data_content = 'test'

    data = @holder.database_format
    assert_match $create_date_regexp, data.create_date
    assert_equal Config::DEFAULT_DIARY_TITLE, data.title
    assert_equal 'test', data.content
  end

end
