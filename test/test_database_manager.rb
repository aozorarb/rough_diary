# frozen_string_literal: true

require "test_helper"
require 'tempfile'

include RoughDiary


class DatabaseManager::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create
    @db_manager = DatabaseManager.new(tmpfile.path)
  end


  def test_manager=
    assert @db_manager.manager = DatabaseManager::Normal
    assert @db_manager.manager = DatabaseManager::Fix

    assert_raises(ArgumentError) { @db_manager.manager = DataHolder::Normal }
  end


  def test_method_missing
    @db_manager.manager = DatabaseManager::Normal
    @db_manager.data_holder = Minitest::Mock.new

    assert @db_manager.register
    assert_raises(NoMethodError) { @db_manager.not_found_method }
  end

end



class DatabaseManager::Normal::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create
    @db_manager = DatabaseManager.new(tmpfile.path)
    @db_manager.manager = DatabaseManager::Normal
    @mock_data_holder = Minitest::Mock.new
    @manager = @db_manager.v_get(:@manager)
    @db = @manager.v_get(:@database)

    @db_manager.data_holder = @mock_data_holder
  end


  def test_initialize
    created_tables =
      @db.execute 'SELECT * FROM sqlite_master'
    
    assert_equal 'diary_entries', created_tables[0]['name']
    assert_equal 'diary_tags',    created_tables[1]['name']
    assert_equal 'idx_tags',      created_tables[3]['name']
  end


  def test_insert_diary_entries
    data_class = Data.define(:create_date, :title, :content)
    data = data_class.new('2000-01-01 00:00:00', 'test', 'goodbye')
    @mock_data_holder.expect :database_format, data

    @manager.send(:insert_diary_entries)

    res =
      @db.execute('SELECT * FROM diary_entries')[0]

    assert_equal 1, res['id']
    assert_equal '2000-01-01 00:00:00', res['create_date']
    assert_equal 'test', res['title']
    assert_equal 'goodbye', res['content']
  end


  def test_insert_diary_tags
    @mock_data_holder.expect :get, '#hello', [:content]
    @mock_data_holder.expect :get, 1, [:id]

    @manager.send(:insert_diary_tags) 

    res =
      @db.execute('SELECT * FROM diary_tags')[0]

    assert_equal 1, res['id']
    assert_equal '#hello', res['tag']
  end
end



class DatabaseManager::Fix::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create
    @db_manager = DatabaseManager.new(tmpfile.path)
    @db_manager.manager = DatabaseManager::Fix
    @mock_data_holder = Minitest::Mock.new
    @manager = @db_manager.v_get(:@manager)
    @db = @manager.v_get(:@database)

    @db_manager.data_holder = @mock_data_holder
  end


  def test_initialize
    created_tables =
      @db.execute 'SELECT * FROM sqlite_master'
    
    assert_equal 'diary_fixies', created_tables[0]['name']
  end


  def test_insert_diary_fixies
    data_class = Data.define(:create_date, :fix_diary_id, :edit_content)
    data = data_class.new('2000-01-01 00:00:00', 1, 'edit test')
    @mock_data_holder.expect :database_format, data

    @manager.send(:insert_diary_fixies)

    res =
      @db.execute('SELECT * FROM diary_fixies')[0]

    assert_equal 1, res['id']
    assert_equal '2000-01-01 00:00:00', res['create_date']
    assert_equal 1, res['fix_diary_id']
    assert_equal 'edit test', res['edit_content']
  end

end


