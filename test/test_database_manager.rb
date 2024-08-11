# frozen_string_literal: true

require "test_helper"
require 'tempfile'

class TestDatabaseManager < Minitest::Test
  def setup
    @tempfile = Tempfile.create('test.db')
    @manager = RoughDiary::DatabaseManager.new(@tempfile.path)
    @db = @manager.instance_variable_get(:@database)
  end

  
  def test_initialize
    assert File.exist?(@tempfile.path), msg = 'database file is created?'
  end


  def test_insert_diary_entries
    @db.results_as_hash = false

    tables = @db.execute <<~SQL
      SELECT name FROM sqlite_master WHERE type == 'table'
    SQL
    tables = tables.flatten

    assert_includes tables, 'diary_entries', msg = 'diary_entries table was created?'
    assert_includes tables, 'diary_tags', msg = 'diary_tags table was created?'
    @db.results_as_hash = true
  end


  def test_register_inserts_data
    mock_savedata_manager = Minitest::Mock.new
    formated_now_time = Time.new.getutc.strftime('%Y-%m-%d %H:%M:%S')

    data_class = Data.define(:title, :create_date, :type, :follow_diary)
    data = data_class.new(
      title: 'example',
      create_date: formated_now_time,
      type: 'normal',
      follow_diary: ''
    )

    mock_savedata_manager.expect :database_format, data
    mock_savedata_manager.expect :file_path, 'test_path'
    mock_savedata_manager.expect :id_data=, true, [Integer]
    mock_savedata_manager.expect :get, '', [Object]

    @manager.savedata_manager = mock_savedata_manager
    @manager.register

    result = @db.execute <<~SQL
      SELECT * FROM diary_entries
    SQL

    assert_equal 1, result.size

    res = result[0]

    assert_equal 'example', res['title']
    assert_equal formated_now_time, res['create_date']
    assert_equal 'normal', res['type']
    assert_equal '', res['follow_diary']
    
    mock_savedata_manager.verify 
  end

end
