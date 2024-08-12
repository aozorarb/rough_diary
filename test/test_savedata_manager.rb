# frozen_string_literal: true

require "test_helper"
require 'tmpdir'
require_relative 'helper/config_define'


class TestSavedataManager < Minitest::Test
  def setup
    @manager = RoughDiary::SavedataManager.new(RoughDiary::Config::SAVEDATA_DIR)
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


  def test_create_savefile_path
    @manager.create_savefile_path
    save_dir = @manager.instance_variable_get(:@savedata_dir)
    file_path = @manager.instance_variable_get(:@file_path)
    assert_match %r(#{save_dir}\/.+\.yml), file_path
    assert_equal true, @manager.instance_variable_get(:@called_create_savefile)
  end


  def test_save
    assert_raises(ScriptError) { @manager.save }

    @manager.id_data = 1
    @manager.content_data = 'example'
    @manager.follow_diary_data = nil

    @manager.create_savefile_path
    @manager.save

    saved_file = File.read(@manager.file_path)
    saved_data = YAML.safe_load(saved_file, permitted_classes: [Time])
    assert_equal 1, saved_data['id']
    assert_equal "default", saved_data['title']
    assert_equal @manager.get(:create_date), saved_data['create_date']
    assert_equal "example", saved_data['content']
    assert_nil saved_data['follow_diary']
  end

end
