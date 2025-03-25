require_relative '../command'
require_relative '../list_view'

class SimpleUi::Commands::List < SimpleUi::Command
  include SimpleUi::ListView

  def initialize
    super 'list',
      'show diaryes list with id',
      'diary list',
      options: {
        limit: {
          type: :value, value: 10, help: '--limit: Limit max number of diaries to list'
        },
        order_by: {
          type: :value, value: 'create_date DESC', help: '--order_by: condition in SQL ORDER BY statement'
        }
      }
  end


  def execute
    limit = @options[:limit][:value]
    order_by = @options[:order_by][:value]

    db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    diaries = @db_manager.collect_diaries(limit: limit, order_by: order_by)
    columns = []
    diaries.each {|diary| columns << [diary['id'], diary['title']] }

    msg = list_view(' id| title', '%03d| %s', columns)
    puts msg
  end
end
