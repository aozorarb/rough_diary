# frozen_string_literal: true

require 'optparse'
require_relative 'version'
require_relative 'database_manager'
require_relative 'savedata_manager'
require_relative 'config'
require_relative 'writer'
require_relative 'reader'

module RoughDiary
  class Core
    
    def initialize
      @writer = RoughDiary::Writer.new
      @reader = RoughDiary::Reader.new
      @database_manager = RoughDiary::DatabaseManager.new
      @savedata_manager = RoughDiary::SavedataManager.new
    end


    def run
      main
    end

    
    private def main
      OptionParser.new do |opt|
        opt.banner = "Usage: diary [options]"

        opt.on('-w', '--write [TITLE]', 'write diary. If TITLE specified, write named diary') do |v|
          @writer.write
        end
        
        opt.on('-r', '--read [TITLE]', 'read diary. If TITLE specified, read TITLE diary') do |v|
          @reader.read
        end
      end.parse!
    end

  end
end
