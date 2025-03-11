require 'configatron'


module SimpleUi
  class Command
    def initialize(command_name, summary, usage, need_args: [], option_help: '')
      @name = command_name
      @summary = summary
      @usage = usage
      @need_args = need_args
      @option_help = option_help
      @args = {}
      @options = {}
    end

    attr_reader :name, :summary, :usage

    def execute
      raise NotImplementedError
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
end

module SimpleUi::Commands; end
