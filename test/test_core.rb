# frozen_string_literal: true

require "test_helper"
require_relative 'helper/config_define'

include RoughDiary

class Core::Test < Minitest::Test
  def setup
    @core = Core.new
  end


  def test_write
    mock_writer = Minitest::Mock.new
    mock_writer.expect :write, true

    Writer.stub :new, mock_writer do
      @core.write
    end

    mock_writer.verify
  end


  def test_read
    mock_reader = Minitest::Mock.new
    mock_reader.expect :read, true

    Reader.stub :new, mock_reader do
      @core.read
    end

    mock_reader.verify
  end

end
