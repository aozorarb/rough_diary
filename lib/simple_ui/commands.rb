require 'configatron'


module SimpleUi
  class Command
    def initialize(command, summary, need_args=[])
      @command = command
      @summary = summary
      @need_args = need_args
      @args = {}
      @options = {}
    end

    attr_reader :command, :summary

    def execute
      binding.break
      raise NotImplementedError
    end

    def usage
      @summary
    end

    def parse_arguments(args)
      if !@need_args.empty? && args.empty?
        usage
        return
      end

      @need_args.each do |name|
        if args.first.start_with?('--')
          usage
        else
          @args[name] = args.pop
        end
      end
      parse_options(args)
    end


    def parse_options(args)
      until args.empty?
        key = args.shift
        val = args.first
        if key.start_with?('--')
          # option without value
          key = key[2..].to_sym
          if val.nil? || val.start_with?('--') 
            @options[key] = true
          else
            @options[key] = val
            args.shift
          end
        else
          warn "Invalid option format: #{args.join(' ')}"
          exit 1
        end
      end
    end

    def invoke(args)
      parse_arguments args 
      execute
    end
  end



  module Commands

    class Write < SimpleUi::Command
      def initialize
        require_relative 'editor'
        super 'write', 'write new diary'
      end

      def usage
        'diary write'
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



    class Show < SimpleUi::Command
      def initialize
        require_relative 'pager'
        super 'show', 'Show diary specified by id', [:id]
      end

      def usage
        'diary show ID'
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
          warn "diary id(#{id}) is not found."
          return
        end
        pager = SimpleUi::Pager.new
        pager.show(data_holder)
      end
    end



    class List < SimpleUi::Command
      def initialize
        super 'list', 'show diaryes list with id'
      end

      def usage
        'diary list'
      end


      def execute
        limit = @options[:limit] || 10
        order_by = @options[:order_by] || 'create_date'

        db_manager = RoughDiary::DatabaseManager.new(configatron.system.database_path)
        diaries = db_manager.execute("SELECT * FROM diary_entries ORDER BY #{order_by} LIMIT #{limit}")
        diaries.each do |diary|
          str = "#{diary['title']} (#{diary['id']})"
          puts str
        end
      end
    end



    class Edit < SimpleUi::Command
      def initialize
        require_relative 'editor'
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



    class Help < SimpleUi::Command
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
  end

end
