require_relative '../command'

class SimpleUi::Commands::Help < SimpleUi::Command
  HELP_MESSAGE =<<~MSG
    RoughDiary is a diary writer/pager without care.
    Usage:
      diary [subcommand]

    subcommands:
      write     write new diary
      list      show diaries list with id
      show      show diary specified by id
      edit      edit diary specified by id
  MSG

  def initialize
    super 'help', 'Show help'
  end

  def self.help
    puts HELP_MESSAGE
  end

  def execute
    puts HELP_MESSAGE
  end

  def system
    msg = <<~MSG
      rough_diary version: #{RoughDiary::VERSION}
      simple_ui version:   #{SimpleUi::VERSION}
      config path:         #{@config_path}
      database path:       #{configatron.system.database_path}
    MSG
    puts msg
  end
end
