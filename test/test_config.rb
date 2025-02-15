require_relative 'test_helper'
include RoughDiary
class Config::Test< Minitest::Test
  include RoughDiary::Config

  def test_constants_not_nil
    Config.constants.all? do |const|
      !const.nil?
    end
  end

end
