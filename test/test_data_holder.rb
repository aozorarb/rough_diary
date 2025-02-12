# frozen_string_literal: true

require 'time'
require_relative "test_helper"
require_relative 'helper/config_define'

include RoughDiary
$create_date_regexp = /.{2}-.{2}-.{2} .{2}:.{2}:.{2}/

class DataHolder::Test < Minitest::Test
  def setup
    @holder = DataHolder.new
  end


  def test_initialize
    assert_nil @holder.id
    assert_instance_of Time, @holder.create_date
    assert_equal Config::DEFAULT_DIARY_TITLE, @holder.title
    assert_nil @holder.content
  end


  def test_database_format
    @holder.content = 'test'

    data = @holder.database_format
    assert_match $create_date_regexp, data.create_date
    assert_equal Config::DEFAULT_DIARY_TITLE, data.title
    assert_equal 'test', data.content
  end


  def test_create_from_database
    db_res = {"id"=>1, "create_date"=>"2000-01-02 03:04:05 +0900", "update_date"=>"2000-01-02 03:04:05 +0900", "title"=>"Test 1", "content"=>"test of test\n"}
    expect_date = Time.parse(db_res['create_date'])
    data_holder = DataHolder.create_from_database(db_res)

    assert_equal db_res['id'], data_holder.id
    assert_equal expect_date, data_holder.create_date
    assert_equal expect_date, data_holder.update_date
    assert_equal db_res['title'], data_holder.title
    assert_equal db_res['content'], data_holder.content
  end

  
  def test_content=
    new_content = 'All delete'
    @holder.content = new_content
    neary_date = Time.now

    diff = (@holder.update_date - neary_date)
    assert_in_delta 0, diff
  end
end
