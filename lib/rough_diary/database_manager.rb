require 'sqlite3'
require 'fileutils'

module RoughDiary
  class DatabaseManager
    def initialize(file_path)

      unless File.exist?(file_path)
        FileUtils.mkpath(File.dirname(file_path))
        FileUtils.touch(file_path)
      end

      @database = SQLite3::Database.new(file_path)
      create_database_if_not_exist

      ObjectSpace.define_finalizer(self, DatabaseManager.finalize(@database))
    end


    def self.finalize(database)
      proc { database&.close }
    end


    private def create_database_if_not_exist
      # mainly database
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_entries (
          id INTEGER PRIMARY KEY,
          diary_path TEXT,
          title TEXT,
          create_date TEXT,
          type TEXT,
          follow_diary INTEGER
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



    def savedata_manager=(manager) @savedata_manager = manager end


    def register
      @database.transaction do
        insert_diary_entries
        set_savedata_id_data_last_inserted
        insert_diary_tags
      end
    end


    private def check_savedata_manager
      unless @savedata_manager
        raise RoughDiary::InstanceVariableNilError,
        "Please set @savedata_manager" unless @savedata_manager
      end
    end


    private def insert_diary_entries
      binding.break
      check_savedata_manager
      sql = <<~SQL
        INSERT INTO diary_entries (
          diary_path, title, create_date, type, follow_diary
        ) VALUES (
          ?, ?, ?, ?, ?
        )
      SQL

      data = @savedata_manager.database_format

      @database.execute sql, [
        @savedata_manager.file_path,
        data.title,
        data.create_date,
        data.type,
        data.follow_diary
      ]
      @database
    end


    private def insert_diary_tags
      check_savedata_manager
      sql = <<~SQL
      INSERT INTO diary_tags
        (id, tag)
      VALUES
        (?, ?)
      SQL

      tag_collector = RoughDiary::TagCollector.new(@savedata_manager)
      tags = tag_collector.collect

      tags.each do |tag|
        @database.execute sql, [
          @savedata_manager.get(:id),
          tag
        ]
      end
      @database
    end


    private def set_savedata_id_data_last_inserted
      check_savedata_manager
      @savedata_manager.id_data = @database.last_insert_row_id
    end

  end
end

