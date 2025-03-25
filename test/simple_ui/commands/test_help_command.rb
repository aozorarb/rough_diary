require_relative '../helper'

class TestCommandHelp < Minitest::Test
  def setup
    @command = SimpleUi::Commands::Help.new
  end


  def test_help_about_bad
    assert_raises(SimpleUi::CommandError) { @command.help_about('Unknown') }
  end

  def test_help_about_good
    exp_output =<<~MSG
      Command: help
      Usage: diary help [CMD_NAME]
      Summary: Show help
    MSG

    assert_output(exp_output) { @command.help_about('help') }
  end
end
