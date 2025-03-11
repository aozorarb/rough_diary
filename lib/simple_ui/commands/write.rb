require_relative '../command'
require_relative '../editor'

class SimpleUi::Commands::Write < SimpleUi::Command
  def initialize
    super 'write', 'write new diary', 'diary write'
  end


  def execute
    db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    data_holder = RoughDiary::DataHolder.new
    editor = Editor.new
    content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

    content_generator.run
    db_manager.register(data_holder)
  end
end

