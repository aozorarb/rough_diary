require 'configatron'


module SimpleUi
  class Command
    # == options
    # hold the command's whole options.
    #
    # = keys
    # name: a option name except double dash prefix '--'
    #   type:  see below
    #   value: option's value
    #   help:  explain what the option does
    #
    # = options type 
    # bool:   on or off
    # value:  need value
    
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
    end


    private def parse_options(args)
      rest_args = []
      until args.empty?
        opt_key = args.shift
        unless opt_key.start_with?('--')
          rest_args << opt_key
          next
        end

        key = opt_key[2..].to_sym
        raise SimpleUi::CommandError, "#{@name} does not accept '#{opt_key}' option" if @options[key].nil?
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
      parse_arguments rest_args 
    end

    def invoke(args)
      parse_options(args)
      execute
    end
  end
end

module SimpleUi::Commands; end
