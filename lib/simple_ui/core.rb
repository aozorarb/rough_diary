require 'rough_diary'
require 'configatron'
require_relative 'command_manager'

module SimpleUi
  VERSION = '0.1.1'


  class Core
    def initialize
      @config_path = File.expand_path('~/.config/rough_diary/config.yml')
      define_config
    end


    private def define_config
      configatron.system.default_diary_title = 'note'
      configatron.system.database_path = File.expand_path('~/.config/rough_diary/default_diary.sqlite3')
      configatron.simple_ui.editor = 'vim'
      configatron.simple_ui.pager = 'view'
      configatron.simple_ui.buffer_path = File.expand_path('~/.config/rough_diary/system_buffer.txt')

      unless File.exist?(@config_path)
        warn "Error: config(#{@config_path}) is not exist. Use default"
      else
        config = YAML.load_file(@config_path)
        configatron.configure_from_hash(config)
        configatron.system.database_path = File.expand_path(configatron.system.database_path)
      end
    end


    def run(args)
      command_manager = SimpleUi::CommandManager.new
      command_manager.run args
    end


    def system_info
      msg = <<~MSG
        rough_diary version: #{RoughDiary::VERSION}
        simple_ui version:   #{SimpleUi::VERSION}
        config path:         #{@config_path}
        database path:       #{configatron.system.database_path}
      MSG
      puts msg
    end


  end
end

