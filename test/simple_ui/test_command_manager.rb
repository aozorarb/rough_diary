require_relative 'helper'


class TestCommandManager < Minitest::Test
  include SimpleUi

  def setup
    @manager = CommandManager.instance
  end

  def test_invoke_command_good
    assert_output(//) { @manager.invoke_command(['help'])}
  end


  def test_invoke_command_bad
    assert_raises(CommandError) { @manager.invoke_command(['bad_command']) }
  end

  
  def test_estimate_command_good
    cmd = @manager.estimate_command('hel') # => help
    assert_instance_of Commands::Help, cmd
  end

  def test_estimate_command_bad
    assert_raises(CommandError) { @manager.estimate_command('404') }
    assert_raises(CommandError) { @manager.estimate_command('s') } # => [show, search]
  end
end 
