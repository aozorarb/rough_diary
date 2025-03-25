require 'singleton'
require_relative 'command'
require_relative 'commands/help'

module SimpleUi
  
  class CommandManager
    include Singleton
    COMMANDS = [
      :write,
      :list,
      :show,
      :edit,
      :search,
      :help,
    ].freeze


    def initialize
      @commands = {}
      COMMANDS.each do |cmd|
        @commands[cmd] = false
      end
    end


    def run(args)
      process_args(args)
    rescue SimpleUi::CommandError
      puts $!
    rescue Interrupt
      puts 'Intrrupted'
      exit 0
    end

    
    def process_args(args)
      if args.empty?
        SimpleUi::Commands::Help.help
        raise SimpleUi::CommandError
      end

      case args.first
      when '-h', '--help'
        SimpleUi::Commands::Help.help
      when '-v', '--version'
        puts "RoughDiary: #{RoughDiary::VERSION}"
        puts "SimpleUi:   #{SimpleUi::VERSION}"
      when /^-/
        raise SimpleUi::CommandError, "Invalid option: #{args.first}. See 'diary --help'"
      else
        invoke_command args
      end
    end


    def invoke_command(args)
      cmd_name = args.shift.downcase
      cmd = estimate_command(cmd_name)
      raise SimpleUi::CommandError unless cmd
      cmd.invoke args
    end


    private def get(command_name)
      command_name = command_name.to_sym
      return nil if @commands[command_name].nil?
      @commands[command_name] ||= instantiate(command_name)
    end


    private def instantiate(command_name)
      command_name = command_name.to_s
      class_name = command_name.capitalize
      require "simple_ui/commands/#{command_name}"
      SimpleUi::Commands.const_get(class_name).new
    end


    private def command_names
      @commands.keys.map(&:to_s).sort
    end


    def estimate_command(cmd_name)
      cmd_name = Regexp.escape(cmd_name)
      matches = command_names.grep(/^#{cmd_name}/)
      if matches.size > 1
        raise SimpleUi::CommandError, "Ambiguous command: #{cmd_name} => [#{matches.join(', ')}]"
      elsif matches.empty?
        raise SimpleUi::CommandError, "Unknown command: #{cmd_name}"
      end

      get(matches.first)
    end
  end
end
