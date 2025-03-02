require 'rough_diary'
require 'configatron'
require_relative 'editor'
require_relative 'pager'
require_relative 'parser'

module SimpleUi
  VERSION = '0.1.0'


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
      configatron.simple_ui.buffer_path = File.expand_path('~/.config/rough_diary/system_buffer.txt')

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


    def list(limit: 10, order_by: 'create_date')
      diaries = @db_manager.execute("SELECT * FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}")
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
      if data_holder.nil?
        puts "diary id: #{id} is not found"
        exit 1
      end
      puts "edit '#{data_holder.title}'"

      editor = SimpleUi::Editor.new
      content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

      content_generator.run(need_title: false)
      @db_manager.update(data_holder)
    end


    def show(id: nil)
      if id.nil?
        print 'Enter diary\'s id: '
        id = gets.to_i
      end

      data_holder = @db_manager.collect_diary_by_id(id)
      if data_holder.nil?
        puts "diary id: #{id} is not found."
        exit 1
      end
      pager = SimpleUi::Pager.new
      pager.show(data_holder)
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


    def help
      msg = <<~MSG
        write - write new diary
        list  - show diaries list with id
        show id - show diary specified by id
        edit id - edit diary specified by id
      MSG
      puts msg
    end

  end
end

