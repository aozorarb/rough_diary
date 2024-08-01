require_relative 'test_helper'

class RoughDiary::Config::Test < Minitest::Test
  include RoughDiary::Config

  def test_constants_not_nil
    RoughDiary::Config.constants.all? do |const|
      !const.nil?
    end
  end


  def test_need_follow_diary_type
    res =
      NEED_FOLLOW_DIARY_TYPE.all? do |need_type_pair|
        need_type = need_type_pair[0]
        VALID_DIARY_TYPE.include?(need_type)
      end

    assert(res)
  end

end
