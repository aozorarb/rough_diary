require_relative '../helper'
require 'simple_ui/commands/list'

class TestListCommand < Minitest::Test
  def setup
    @command = SimpleUi::List.new
  end

end
