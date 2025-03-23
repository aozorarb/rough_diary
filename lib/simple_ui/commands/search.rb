require 'rough_diary/database_manager'
require_relative '../command'
require_relative '../list_view'

class SimpleUi::Commands::Search < SimpleUi::Command
  include SimpleUi::ListView
  def initialize
    super 'search',
      'search diary by context or tag',
      'diary search {args}',
      need_args: [:query],
      options: {
        tag: {
          type: :bool, value: false, help: '--tag: search by tag. separate by ,'
        }
      }
  end


  def execute
    @db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)

    if @options[:tag][:value]
      # note: tag option does not disable automatically
      search_by_tags
    else
      search_by_context
    end
  end


  private def parse_query
    if @args[:query].nil?
      raise SimpleUi::CommandError, 'search command need query'
    end
    query = @args[:query].split(',').map(&:strip)
    return query
  end


  private def search_by_tags
    tags = parse_query
    tag = tags.first

    sql = <<~SQL
      SELECT tag, id FROM diary_tags
      WHERE tag LIKE "%#{tag}%"
    SQL

    diaries = []
    tags, ids = [], []
    @db_manager.results_as_array do
      matches = @db_manager.execute(sql)
      matches.each do |match|
        tags << match[0]
        ids << match[1]
      end
      ids.each do |id|
        sql = "SELECT id, title FROM diary_entries WHERE id = #{id}"
        diaries << @db_manager.execute(sql).first
      end
    end
    if diaries.empty?
      puts 'Not found'
    else
      # multibyte character use 2- space but size is 1
      columns = []
      tags.size.times do |i|
        columns << [tags[i], diaries[i][0], diaries[i][1]]
      end
      msg = list_view("tags            | id|title", "%-16s|%03d|%-10s", columns)
      puts msg
    end
  end


  private def search_by_context
    substr = parse_query.first
    sql_where = %Q(content LIKE "%#{substr}%")
    sql = <<~SQL
      SELECT id, title FROM diary_entries
      WHERE #{sql_where}
    SQL
    diaries = nil
    @db_manager.results_as_array do
      diaries = @db_manager.execute(sql)
    end
    if diaries.empty?
      puts 'Not found'
    else
      msg = list_view(" id|title", "%03d|%-10s", diaries)
      puts msg
    end
  end
end
