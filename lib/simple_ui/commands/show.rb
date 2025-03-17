require_relative '../command'
require_relative '../pager'

class SimpleUi::Commands::Show < SimpleUi::Command
  def initialize
    super 'show',
      'Show diary specified by id',
      'diary show ID',
      need_args: [:id]
  end


  def execute
    db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    id = @args[:id]

    if id.nil?
      print 'Enter diary\'s id: '
      inp = gets.chomp
      if /\D/.match?(inp)
        puts "#{inp} is not a number"
        return
      end
      id = inp.to_i
    end

    data_holder = db_manager.collect_diary_by_id(id)
    if data_holder.nil?
      warn "diary id(#{id}) is not found."
      return
    end
    pager = SimpleUi::Pager.new
    pager.show(data_holder)
  end
end

