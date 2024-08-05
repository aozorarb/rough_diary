# frozen_string_literal: true

require "test_helper"

module RoughDiary::Config
  DEFAULT_DIARY_TITLE = 'default'
  VALID_DIARY_TYPE = {
    normal: true,
    append: true,
    fix:    true
  }
  NEED_FOLLOW_DIARY_TYPE = {
    append: true,
    fix:    true
  }
  SAVEDATA_DIR = './resorce/savedata'

end



class TestSavedataManager < Minitest::Test
  def setup
    @manager = RoughDiary::SavedataManager.new
  end


  def test_set_content_data
    @manager.content_data = 'example'
    assert_equal 'example', @manager.get(:content)
  end

  def test_set_follow_diary_data
    @manager.follow_diary_data = 1
    assert_equal 1, @manager.get(:follow_diary)
  end

  def test_set_id_data
    @manager.id_data = 1
    assert_equal 1, @manager.get(:id)
  end


  def test_get_invalid_key
    assert_raises(ArgumentError) { @manager.get(:invalid_key) }
  end


  def test_initialize
    assert_equal "default", @manager.get(:title)
    assert_instance_of Time, @manager.get(:create_date)
    assert_equal :normal, @manager.get(:type)
    assert_nil @manager.get(:content)
    assert_nil @manager.get(:id)
    assert_nil @manager.get(:follow_diary)
  end


  def test_save
    @manager.id_data = 1
    @manager.content_data = 'example'
    @manager.follow_diary_data = nil

    @manager.save
    saved_data = YAML.load_file(@manager.file_path)

    assert_equal 1, saved_data['id']
    assert_equal "Test Title", saved_data['title']
    assert_equal @manager.get(:create_date), saved_data['create_data']
    assert_equal "Test Content", saved_data['content']
    assert_nil saved_data['follow_diary']
  end

end
