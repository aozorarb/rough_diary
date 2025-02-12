# frozen_string_literal: true

require "test_helper"
require 'tempfile'

include RoughDiary

CORRECT_DATA = {
  id: 1,
  create_date: '2000-01-01 00:00:00 +0900',
  update_date: '2000-01-01 00:00:00 +0900',
  title: 'title',
  content: '#tag'
}

class DatabaseManager::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create
    @db_manager = DatabaseManager.new(tmpfile.path)
    @data_holder = DataHolder.new
    @db = @db_manager.v_get(:@database)

    @data_holder.v_set(:@id, CORRECT_DATA[:id])
    @data_holder.v_set(:@create_date, CORRECT_DATA[:create_date])
    @data_holder.v_set(:@update_date, CORRECT_DATA[:update_date])
    @data_holder.v_set(:@title, CORRECT_DATA[:title])
    @data_holder.v_set(:@content, CORRECT_DATA[:content])

    @db_manager.data_holder = @data_holder
  end


  def test_initialize
    created_tables =
      @db.execute 'SELECT * FROM sqlite_master'
    
    assert_equal 'diary_entries', created_tables[0]['name']
    assert_equal 'diary_tags',    created_tables[1]['name']
    assert_equal 'idx_tags',      created_tables[3]['name']
  end


  def test_insert_diary_entries

    @db_manager.send(:insert_diary_entries)

    res = @db.execute('SELECT * FROM diary_entries')[0]

    assert_equal CORRECT_DATA[:id], res['id']
    assert_equal CORRECT_DATA[:create_date], res['create_date']
    assert_equal CORRECT_DATA[:update_date], res['update_date']
    assert_equal CORRECT_DATA[:title], res['title']
    assert_equal CORRECT_DATA[:content], res['content']
  end


  def test_insert_diary_tags
    @db_manager.send(:insert_diary_tags)

    res = @db.execute('SELECT * FROM diary_tags')[0]

    assert_equal CORRECT_DATA[:id], res['id']
    assert_equal "#tag", res['tag']
  end


  def test_collect_diary_by_id
    @db_manager.send(:insert_diary_entries)

    res_dh = @db_manager.collect_diary_by_id(CORRECT_DATA[:id])
    parsed_create_date = Time.parse(CORRECT_DATA[:create_date])
    parsed_update_date = Time.parse(CORRECT_DATA[:update_date])

    assert_equal parsed_create_date, res_dh.create_date
    assert_equal parsed_update_date, res_dh.update_date
    assert_equal CORRECT_DATA[:title], res_dh.title
    assert_equal CORRECT_DATA[:content], res_dh.content
  end

end

