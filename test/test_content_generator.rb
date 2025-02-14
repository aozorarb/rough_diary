# frozen_string_literal: true

require "test_helper"

include RoughDiary

class ContentGenerator::Test < Minitest::Test
  def setup
    @data_holder = DataHolder
    @mock_tempfile = Minitest::Mock.new
    @mock_tempfile.expect :close, true

    Tempfile.stub :create, @mock_tempfile do
      @generator = ContentGenerator.new(@data_holder)
    end

  end


  def test_run
    @mock_tempfile.expect :read, 'mock diary content'
    @mock_tempfile.expect :reopen, true, ['path/to', 'r']
    @mock_tempfile.expect :path, 'path/to'
    @data_holder.expect :data_content=, nil, ['mock diary content']

    @generator.stub :edit_tempfile, nil do
      @generator.stub :ask_diary_title, true do
        @generator.run
      end
    end

    @mock_tempfile.verify
  end


  def suppress_output
    stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
    yield
  ensure
    $stdout = stdout
  end


  def test_ask_diary_title
    suppress_output do
      @data_holder.expect :data_title=, nil, ['test title']

      @generator.stub :gets, "test title\n" do
        @generator.send(:ask_diary_title)
      end

    end
  end


  def test_ask_diary_title_is_none
    suppress_output do
      @generator.stub :gets, "\n" do
        @generator.send(:ask_diary_title)
      end

    end
  end

end
