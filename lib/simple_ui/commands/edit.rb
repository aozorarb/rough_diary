require_relative '../command'
require_relative '../editor'
class SimpleUi::Commands::Edit < SimpleUi::Command
  def initialize
    super 'edit', 'Edit diary specified by id', [:id]
  end

  def usage
    'diary edit Edit-diary-id'
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
      puts "diary id: #{id} is not found"
      return
    end
    puts "edit '#{data_holder.title}'"

    editor = SimpleUi::Editor.new
    content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

    content_generator.run(need_title: false)
    db_manager.update(data_holder)
  end

end
