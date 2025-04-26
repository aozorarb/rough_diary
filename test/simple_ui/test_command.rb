require_relative 'helper'

class SimpleUi::Command
  public :parse_arguments, :parse_options
  attr_accessor :name, :summary, :usage, :args
end


class TestCommand < Minitest::Test


  def test_execute
    cmd = SimpleUi::Command.new('test', 'test', '')
    assert_raises(NotImplementedError) { cmd.execute }
  end


  def test_parse_arguments
    # none
    cmd = SimpleUi::Command.new('test', 'test', '')
    assert_equal cmd.usage, cmd.send(:parse_arguments, [])

    # need_args 1, give args 0
    cmd = SimpleUi::Command.new('test', 'test', '', need_args: ['arg1'])
    assert_equal cmd.usage, cmd.send(:parse_arguments, [])
    
    # need_args 2, give args 2
    cmd = SimpleUi::Command.new('test', 'test', '', need_args: ['arg1', 'arg2'])
    cmd.send(:parse_arguments, ['one', 'two'])
    assert_equal 'one', @args['one']
    assert_equal 'two', @args['two']

    # need_args 1, give args 1, option style 1
    cmd = SimpleUi::Command.new('test', 'test', '', need_args: ['arg1'])
    assert_equal cmd.usage, cmd.send(:parse_arguments, ['--invalid', 'one'])
  end


  def test_parse_options
    
  end
end



