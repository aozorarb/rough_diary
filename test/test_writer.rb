# frozen_string_literal: true

require "test_helper"
require 'minitest/mock'

class TestWriter < Minitest::Test
  def setup
    @mock_database_manager = Minitest::Mock.new
    @mock_savedata_manager = Minitest::Mock.new
    @mock_content_generator = Minitest::Mock.new
    @writer = RoughDiary::Writer.new(@mock_database_manager)
  end

  
  def test_write
    @mock_database_manager.expect :savedata_manager=, nil, [@mock_savedata_manager]
    @mock_database_manager.expect :register, nil
    @mock_content_generator.expect :run, nil

    @writer.instance_variable_set :@savedata_manager, @mock_savedata_manager
    @writer.instance_variable_set :@content_generator, @mock_content_generator


    @writer.write

    @mock_content_generator.verify
    @mock_database_manager.verify
  end
end
