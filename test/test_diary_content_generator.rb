# frozen_string_literal: true

require "test_helper"

class TestDiaryContentGenerator < Minitest::Test
  def setup
    @mock_savedata_manager = Minitest::Mock.new
    @mock_tempfile = Minitest::Mock.new

    Tempfile.stub :create, @mock_tempfile do
      @generator = RoughDiary::DiaryContentGenerator.new(@mock_savedata_manager)
    end

  end


  def test_run
    @mock_tempfile.expect :read, 'mock diary content'
    @mock_savedata_manager.expect :content_data=, nil, ['mock diary content']

    @generator.stub :edit_tempfile, nil do
      @generator.run
    end

    @mock_tempfile.verify
    @mock_savedata_manager.verify
  end


  def test_valid_editor?
    assert @generator.send(:valid_editor?, 'vim')
    refute @generator.send(:valid_editor?, 'invalid_editor')
  end


  def test_edit_tempfile_raise_error_for_invalid_editor
    @generator.stub :valid_editor?, false do
      assert_raises(RoughDiary::InvalidConfigrationError) do
        @generator.send(:edit_tempfile, editor: 'invalid_editor')
      end
    end
  end

end
