# frozen_string_literal: true

require 'optparse'
require_relative 'version'
require_relative 'database_manager'
require_relative 'data_holder'
require_relative 'tag_collector'
require_relative 'config'
require_relative 'writer'
require_relative 'reader'

module RoughDiary
  class Core
    include RoughDiary

    def initialize
      @database_manager = DatabaseManager.new(RoughDiary::Config::DATABASE_PATH)
    end

    
    def run
      main
    end

    
    private def main
      OptionParser.new do |opt|
        opt.banner = "Usage: diary [options]"

        opt.on('-w', '--write [TITLE]', 'write diary. If TITLE specified, write named diary') do |v|
          @writer = Writer.new(@database_manager, title: v[0])
          @writer.write
        end
        
        opt.on('-r', '--read [TITLE]', 'read diary. If TITLE specified, read TITLE diary') do |v|
          @reader = Reader.new(@database_manager)
          @reader.read
        end

      end.parse!
    end

  end
end
