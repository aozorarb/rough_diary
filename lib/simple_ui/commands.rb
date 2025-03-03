require 'configatron'


module SimpleUi
  class Command
    def initialize(command, summary=nil)
      @command = command
      @summary = summary
    end

    attr_reader :command, :summary

    def execute
      raise NotImplementedError
    end
  end



  module Commands
    include SimpleUi

    class Write < Command
      def initialize
        require_relative 'editor'
        super 'write', 'write new diary'
      end
        
      def execute
        db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
        data_holder = RoughDiary::DataHolder.new
        editor = Editor.new
        content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

        content_generator.execute
        db_manager.register(data_holder)
      end
    end
  end



  class Show < Command
    def initialize
      require_relative 'pager'
      super 'show', 'Show diary specified by id'
    end

    def execute(id: nil)
      db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)

      if id.nil?
        print 'Enter diary\'s id: '
        id = gets.to_i
      end

      data_holder = db_manager.collect_diary_by_id(id)
      if data_holder.nil?
        puts "diary id: #{id} is not found."
        exit 1
      end
      pager = SimpleUi::Pager.new
      pager.show(data_holder)
    end
  end



  class List < Command
    def initialize
      super 'list', 'show diaryes list with id'
    end

    def execute(limit: 10, order_by: 'create_date')
      db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
      diaries = db_manager.execute("SELECT * FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}")
      diaries.each do |diary|
        str = "#{diary['title']} (#{diary['id']})"
        puts str
      end
    end
  end



  class Edit < Command
    def initialize
      require_relative 'editor'
      super 'edit', 'Edit diary specified by id'
    end

    def execute(id: nil)
      db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
      if id.nil?
        print 'Enter diary\'s id: '
        id = gets.to_i
      end

      data_holder = db_manager.collect_diary_by_id(id)
      if data_holder.nil?
        puts "diary id: #{id} is not found"
        exit 1
      end
      puts "edit '#{data_holder.title}'"

      editor = SimpleUi::Editor.new
      content_generator = RoughDiary::ContentGenerator.new(data_holder, editor)

      content_generator.execute(need_title: false)
      db_manager.update(data_holder)
    end

  end



  class Help < Command
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

  end
end
