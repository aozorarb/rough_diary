# frozen_string_literal: true

require "test_helper"

class TestWriter < Minitest::Test
  def setup
    @mock_content_generator = Minitest::Mock.new
    @mock_savedata_manager = Minitest::Mock.new
    @mock_database_manager = Minitest::Mock.new
    
    Kernel.module_exec do
      alias_method :v_get ,:instance_variable_get
      alias_method :v_set ,:instance_variable_set
    end
    
    @mock_database_manager.expect :savedata_manager=, true, [RoughDiary::SavedataManager]
    @writer = RoughDiary::Writer.new(@mock_database_manager)
  end

  def test_write
    @mock_content_generator.expect :run, true
    @mock_savedata_manager.expect :create_savefile_path, true
    @mock_savedata_manager.expect :save, true
    @mock_database_manager.expect :register, true

    @writer.v_set :@database_manager, @mock_database_manager
    @writer.v_set :@savedata_manager, @mock_savedata_manager
    @writer.v_set :@content_generator, @mock_content_generator

    @writer.write

    @mock_database_manager.verify
    @mock_savedata_manager.verify
    @mock_content_generator.verify
  end
end
