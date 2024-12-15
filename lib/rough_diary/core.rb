# frozen_string_literal: true

require_relative 'version'
require_relative 'database_manager'
require_relative 'data_holder'
require_relative 'config'
require_relative 'writer'
require_relative 'reader'
require_relative 'editor'


module RoughDiary
  class Core
    include RoughDiary

    def initialize
      @database_manager = DatabaseManager.new(Config::DATABASE_PATH)
      @database_manager.manager = DatabaseManager::Normal
    end
    
    def write
      # write a diary. If the title specified, write named diary
      writer = Writer.new(@database_manager)#, title: ARGV[0])
      writer.write
    end


    def read(id)
      # get diary id, read the id diary
      reader = Reader.new(@database_manager)
      reader.read(id)
    end


    def edit(diary_id)
      editor = Editor.new(@database_manager) 
      editor.edit(diary_id)
    end
  end
end
