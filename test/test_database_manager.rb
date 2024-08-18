# frozen_string_literal: true

require "test_helper"
require 'tempfile'

include RoughDiary


class DatabaseManager::Test < Minitest::Test
end

class DatabaseManager::Normal::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create.close
    @manager = DatabaseManager.new(tmpfile.path)
    @manager.manager = DatabaseManager::Normal
  end

end



class DatabaseManager::Fix::Test < Minitest::Test
  def setup
    tmpfile = Tempfile.create.close
    @manager = DatabaseManager.new(tmpfile.path)
    @manager.manager = DatabaseManager::Fix
  end
end
