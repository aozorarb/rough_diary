require_relative 'test_helper'

include RoughDiary

class TagCollector::Test < Minitest::Test
  def setup
    @mock_savedata_manager = Minitest::Mock.new
    @tag_collector = TagCollector.new(@mock_savedata_manager)
  end


  def test_collect
    @mock_savedata_manager.expect :get, 'test/resource/tag_collector/one_tag.yml'
  end
end
