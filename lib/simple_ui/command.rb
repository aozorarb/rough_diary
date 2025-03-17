require 'configatron'


module SimpleUi
  class Command
    def initialize(command_name, summary, usage, need_args: [], options: {})
      @name = command_name
      @summary = summary
      @usage = usage
      @need_args = need_args
      @options = options
      @args = {}
    end

    attr_reader :name, :summary, :usage

    def execute
      raise NotImplementedError
    end

    private def parse_arguments(args)
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


    # options type 
    # - :bool: on or off
    # - :value: need value
    private def parse_options(args)
      until args.empty?
        opt_key = args.shift
        raise SimpleUi::CommandError, "Invalid option format: #{args}" unless opt_key.satrt_with?('--')

        key = opt_key[2..].to_sym
        raise SimpleUi::CommandError, "#{@name} does not accept '#{opt_key}' option"
        raise SimpleUi::CommandError, "'#{key}' option need value" if @options[key][:type] == :value && args.first.nil?
        case @options[key][:type]
        when :bool
          @options[key][:value] = true
        when :value
          val = args.shift
          @options[key][:value] = val
        else
          raise ArgumentError, "Invalid accept type: #{key.name}"
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
