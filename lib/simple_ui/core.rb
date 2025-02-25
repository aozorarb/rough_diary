require 'rough_diary'
require 'configatron'
require_relative 'editor'

module SimpleUi
  class Core
    def initialize
      @config_path = File.expand_path('~/.config/rough_diary/config.yml')
      define_config

      @db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
    end


    private def define_config
      configatron.system.default_diary_title = 'note'
      configatron.system.database_path = File.expand_path('~/.config/rough_diary/default_diary.sqlite3')
      configatron.simple_ui.editor = 'vim'
      configatron.simple_ui.pager = 'view'

      unless File.exist?(@config_path)
        warn "Error: config(#{@config_path}) is not exist. Use default"
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
      @db_manager.register(data_holder)
    end


    def list(limit: 10, order_by: create_date)
      diaries = @db_manager.execute("SELECT * FROM diary_entries ORDER BY #{create_date} LIMIT #{limit}")
      diaries.each do |diary|
        str = "#{diary['title']} (#{diary['id']})"
        puts str
      end
    end


    def edit(id: nil)
      if id.nil?
        print 'Enter diary\'s id: '
        id = gets.to_i
      end

      data_holder = @db_manager.collect_diary_by_id(id)
      if data_holder
        puts "edit '#{data_holder.title}'"
      else
        warn "Not found to diary id #{data_holder.id}"
        exit 1
      end
      editor = SimpleUi::Editor.new
      content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

      content_generator.run(need_title: false)
      @db_manager.update(data_holder)
    end
  end
end

