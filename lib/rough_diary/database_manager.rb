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
      @database.results_as_hash = true
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



    def data_holder=(val) @data_holder = val end


    def register
      @database.transaction do
        insert_diary_entries
        set_savedata_id_data_last_inserted
        insert_diary_tags
      end
    end


    private def check_data_holder
      unless @data_holder
        raise RoughDiary::InstanceVariableNilError,
        "Please set @data_holder" unless @data_holder
      end
    end


    private def insert_diary_entries
      check_data_holder
      sql = <<~SQL
        INSERT INTO diary_entries (
          diary_path, title, create_date, type, follow_diary
        ) VALUES (
          ?, ?, ?, ?, ?
        )
      SQL

      data = @data_holder.database_format

      @database.execute sql, [
        @data_holder.file_path,
        data.title,
        data.create_date,
        data.type,
        data.follow_diary
      ]
      @database
    end


    private def insert_diary_tags
      check_data_holder
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


    private def set_savedata_id_data_last_inserted
      check_data_holder
      @data_holder.id_data = @database.last_insert_row_id
    end

  end
end

