require_relative '../command'

class SimpleUi::Commands::List < SimpleUi::Command
  def initialize
    super 'list', 'show diaryes list with id'
  end

  def usage
    'diary list'
  end


  def execute
    limit = @options[:limit] || 10
    order_by = @options[:order_by] || 'create_date'

    db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    diaries = db_manager.execute("SELECT * FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}")
    diaries.each do |diary|
      str = "#{diary['title']} (#{diary['id']})"
      puts str
    end
  end
end
