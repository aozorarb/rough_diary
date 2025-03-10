require_relative '../command'

class SimpleUi::Commands::List < SimpleUi::Command
  def initialize
    super 'list', 'show diaryes list with id'
  end

  def usage
    'diary list'
  end


  private def truncate_text(str, max_size: 50)
    raise ArgumentError, 'max_size must be positive' if max_size.negative?
    res = str.dup
    if str.size > max_size
      str_size = [str.size, max_size].min
      res[str_size-3..] = '...'
    end
    res
  end

  def execute
    limit = @options[:limit] || 10
    order_by = @options[:order_by] || 'create_date'

    db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    diaries = db_manager.execute("SELECT * FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}")
    puts '  id | title'
    diaries.each do |diary|
      id = diary['id'].to_i
      title = truncate_text(diary['title'])
      str = format("% 4d | %s", id, title)
      puts str
    end
  end
end
