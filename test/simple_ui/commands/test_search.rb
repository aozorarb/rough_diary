require_relative '../helper'

class SimpleUi::Commands::Search
  public :parse_query, :search_by_tags, :search_by_context
end


class TestSearch < Minitest::Test
  def setup
    @cmd = SimpleUi::Commands::Search.new
  end


  def test_parse_query
    @cmd.args = ['hello']
    res = @cmd.parse_query

    @cmd.args = ['--tag', 'one']
    res = @cmd.parse_query

    @cmd.args = ['hello AND goodbye']
    res = @cmd.parse_query

    @cmd.args = ['hello OR goodbye']
    res = @cmd.parse_query

  end


  def test_search_by_tags
  end


  def test_search_by_context
  end
end
