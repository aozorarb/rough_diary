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
    diaries = nil
    db_manager.results_as_array do
      diaries = db_manager.execute(
        "SELECT id, title FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}"
      )
    end
    msg = list_view(' id| title', '%03d| %s', diaries)
    puts msg
  end
end
