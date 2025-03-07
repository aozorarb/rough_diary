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
end

module SimpleUi::Commands; end
