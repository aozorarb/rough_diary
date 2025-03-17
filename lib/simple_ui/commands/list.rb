require_relative '../command'
require_relative '../list_view'

class SimpleUi::Commands::List < SimpleUi::Command
  include SimpleUi::ListView

  def initialize
    super 'list',
      'show diaryes list with id',
      'diary list'
  end




  def execute
    limit = @options[:limit] || 10
    order_by = @options[:order_by] || 'create_date'

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
