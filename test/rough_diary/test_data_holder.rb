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
    assert_nil @holder.create_date
    assert_nil @holder.update_date
    assert_equal configatron.system.default_diary_title, @holder.title
    assert_nil @holder.content
  end


  def test_database_format
    @holder.content = 'test'

    data = @holder.database_format
    assert_match $create_date_regexp, data.create_date
    assert_match $create_date_regexp, data.update_date
    assert_equal configatron.system.default_diary_title, data.title
    assert_equal 'test', data.content
  end


  def test_create_from_database
    db_res = {"id"=>'1', "create_date"=>"2000-01-02 03:04:05 +0900", "update_date"=>"2000-01-02 03:04:05 +0900", "title"=>"Test 1", "content"=>"test of test\n"}
    expect_date = Time.parse(db_res['create_date'])
    data_holder = DataHolder.create_from_database(db_res)

    assert_equal db_res['id'], data_holder.id
    assert_equal expect_date, data_holder.create_date
    assert_equal expect_date, data_holder.update_date
    assert_equal db_res['title'], data_holder.title
    assert_equal db_res['content'], data_holder.content
  end

  
  def test_content=
    @holder.content = 'First'
    neary_date = Time.now

    c_diff = (@holder.create_date - neary_date)
    u_diff = (@holder.update_date - neary_date)
    assert_in_delta 0, c_diff
    assert_in_delta 0, u_diff

    # twice 
    sleep 0.01
    @holder.content = 'Second'
    c2_diff = (@holder.create_date - neary_date)
    u2_diff = (@holder.update_date - neary_date)
    assert_in_delta c_diff, c2_diff
    assert_in_delta u_diff, u2_diff, delta = 0.02
  end

end
