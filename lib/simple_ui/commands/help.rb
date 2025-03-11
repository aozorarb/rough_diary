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
    super 'help', 'Show help', 'diary help [CMD_NAME]', need_args: [:cmd_name]
    @command_manager = SimpleUi::CommandManager.instance
  end


  def self.help
    puts HELP_MESSAGE
  end


  def execute
    if @args[:cmd_name]
      help_about(@args[:cmd_name])
    else
      puts HELP_MESSAGE
    end
  end


  def help_about(cmd_name)
    cmd = @command_manager.estimate_command(cmd_name)
    msg =<<~MSG
      Command: #{cmd.name}
      Usage: #{cmd.usage}
      Summary: #{cmd.summary}
    MSG
    puts msg
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
