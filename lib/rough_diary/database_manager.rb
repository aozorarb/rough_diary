require 'sqlite3'
require 'fileutils'

module RoughDiary
  class DatabaseManager
    def initialize(db_path)
      unless File.exist?(db_path)
        FileUtils.mkpath(File.dirname(db_path))
        FileUtils.touch(db_path)
      end

      @database = SQLite3::Database.new(db_path)
      @database.results_as_hash = true
      ObjectSpace.define_finalizer(self, RoughDiary::DatabaseManager.db_finalize(@database))

      @manager = nil
    end


    def self.db_finalize(database)
      proc { database&.close }
    end

    
    def manager=(klass)
      @manager = klass.new(@database)
    rescue
      puts 'Specify DatabaseManager::{Normal, Fix}'
      puts $!
    end


    def method_missing(method, *args)
      @manager&.public_send(method, *args)
    rescue
      super
    end


    def respond_to_missing?(sym, include_private)
      @manager&.respond_to?(sym) ? true : super
    end

  end
end



class RoughDiary::DatabaseManager

  class Base
    def initialize(database)
      @database = database
      create_database_if_not_exist
    end


    def data_holder=(val) @data_holder = val end


    private def check_data_holder
      unless @data_holder
        raise RoughDiary::InstanceVariableNilError,
        "Please set @data_holder" unless @data_holder
      end
    end


    private def set_data_id_last_inserted
      check_data_holder
      @data_holder.id_data = @database.last_insert_row_id
    end


    private def create_database_if_not_exist() raise NotImplementedError end
    private def register() raise NotImplementedError end

  end



  class Normal < Base
    private def create_database_if_not_exist
      # mainly database
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_entries (
          id INTEGER PRIMARY KEY,
          create_date TEXT,
          title TEXT,
          content TEXT
        );
      SQL

      # tag database
      # reference mainly database's "id"
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_tags (
          id INTEGER,
          tag TEXT,
          FOREIGN KEY (id) REFERENCES diary_entries(id),
          UNIQUE(id, tag)
        );
      SQL

      # Create indexies of tags for searching
      @database.execute <<~SQL
        CREATE INDEX IF NOT EXISTS idx_tags ON diary_tags (tag);
      SQL
      @database
    end


    def register
      check_data_holder

      @database.transaction do
        insert_diary_entries
        set_data_id_last_inserted
        insert_diary_tags
      end
    end


    private def insert_diary_entries
      sql = <<~SQL
        INSERT INTO diary_entries (
          create_date, title, content
        ) VALUES (
          ?, ?, ?
        )
      SQL

      data = @data_holder.database_format

      @database.execute sql, [
        data.create_date,
        data.title,
        data.content
      ]
      @database
    end


    private def insert_diary_tags
      sql = <<~SQL
      INSERT INTO diary_tags
        (id, tag)
      VALUES
        (?, ?)
      SQL

      tag_collector = RoughDiary::TagCollector.new(@data_holder)
      tags = tag_collector.collect

      tags.each do |tag|
        @database.execute sql, [
          @data_holder.get(:id),
          tag
        ]
      end
      @database
    end

  end



  class Fix < Base
    private def create_database_if_not_exist
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_fixies (
          id INTEGER PRIMARY KEY,  
          create_date TEXT,
          fix_diary_id INTEGER,
          edit_content TEXT
        );
      SQL
    end


    private def insert_diary_fixies
      sql = <<~SQL
        INSERT INTO diary_fixies (
          create_date, fix_diary_id, edit_content
        )
      SQL

      data = @data_holder.database_format

      @database.execute sql, [
        data.create_date,
        data.fix_diary_id,
        data.edit_content
      ]
      @database
    end


    def register
      check_data_holder
      @database.transaction do
        insert_diary_fixies
        set_data_id_last_inserted
      end
    end
  end

end
