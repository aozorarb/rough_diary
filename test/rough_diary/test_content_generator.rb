# frozen_string_literal: true

require_relative "test_helper"

include RoughDiary

class ContentGenerator::Test < Minitest::Test
  def setup
    @data_holder = DataHolder.new
    @mock_tempfile = Minitest::Mock.new
    @mock_tempfile.expect :write, nil, [nil]
    @mock_tempfile.expect :close, true
    @mock_editor = Minitest::Mock.new
    Tempfile.stub :create, @mock_tempfile do
      @generator = ContentGenerator.new(@data_holder, @mock_editor)
    end
  end


  def test_run
    @mock_editor.expect :edit, true, [Minitest::Mock]
    @mock_editor.expect :diary_title, 'title'
    @mock_tempfile.expect :reopen, true, ['path/to', 'r']
    @mock_tempfile.expect :path, 'path/to'
    @mock_tempfile.expect :read, 'mock diary content'

    @generator.run

    @mock_editor.verify
    @mock_tempfile.verify
  end

end
