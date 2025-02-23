require 'rough_diary'
require 'configatron'
require_relative 'editor'

class SimpleUI
  class Core
    def initialize
      @config_path = File.expand_path('~/.config/rough_diary/config.yaml')
      define_config

      @db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    end

    private def define_config
      configatron.system.default_diary_title = 'note'
      configatron.system.database_path = File.expand_path('~/.config/rough_diary/diary.sqlite3')
      configatron.simple_ui.editor = 'vim'
      configatron.simple_ui.pager = 'view'

      unless File.exist?(@config_path)
        warn 'Error: config.yml(#{@config_path}) is not exist. Use default'
      else
        config = YAML.load_file(@config_path)
        configatron.configure_from_hash(config)
        configatron.system.database_path = File.expand_path(configatron.system.database_path)
      end
    end


    def write
      data_holder = RoughDiary::DataHolder.new
      editor = SimpleUi::Editor.new
      content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

      content_generator.run
      @db_manager.data_holder = data_holder
      @db_manager.register
    end
  end
end

