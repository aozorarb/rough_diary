require 'sqlite3'
require 'fileutils'
require_relative 'diary_utils'


module RoughDiary

  class DatabaseManager
    include RoughDiary

    def initialize(db_path)
      unless File.exist?(db_path)
        FileUtils.mkpath(File.dirname(db_path))
        FileUtils.touch(db_path)
      end

      @database = SQLite3::Database.new(db_path)
      @database.results_as_hash = true

      ObjectSpace.define_finalizer(self, DatabaseManager.db_finalize(@database))

      create_database_if_not_exist
    end


    def self.db_finalize(database)
      proc { database&.close }
    end


    private def create_database_if_not_exist
      # mainly database
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_entries (
          id INTEGER PRIMARY KEY,
          create_date TEXT,
          update_date TEXT,
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


    private def insert_diary_entries(data_holder)
      sql = <<~SQL
        INSERT INTO diary_entries (
          create_date, update_date, title, content
        ) VALUES (
          ?, ?, ?, ?
        )
      SQL
      data = data_holder.database_format

      @database.execute sql, [
        data.create_date,
        data.update_date,
        data.title,
        data.content
      ]
      @database
    end


    private def update_diary_entries(data_holder)
      data = data_holder.database_format
      sql = <<~SQL
        UPDATE diary_entries
        SET update_date = "#{data.update_date}", content = "#{data.content}"
        WHERE id = "#{data.id}"
      SQL
      @database.execute sql
      @database
    end


    private def update_diary_tags(data_holder)
      sql = <<~SQL
        DELETE FROM diary_tags
        WHERE id = "#{data_holder.id}"
      SQL
      @database.execute sql

      insert_diary_tags(data_holder)
    end


    private def insert_diary_tags(data_holder)
      sql = <<~SQL
      INSERT INTO diary_tags
        (id, tag)
      VALUES
        (?, ?)
      SQL

      tags = DiaryUtils.tag_collect(data_holder)

      tags.each do |tag|
        @database.execute sql, [
          data_holder.id,
          tag
        ]
      end
      @database
    end


    private def data_id_last_inserted
      @database.last_insert_row_id
    end


    def execute(query)
      @database.execute(
        SQLite3::Database.quote(query)
      )
    end


    def register(data_holder)
      @database.transaction do
        insert_diary_entries(data_holder)
        data_holder.id = @database.last_insert_row_id
        insert_diary_tags(data_holder)
      end
    end


    def update(data_holder)
      @database.transaction do
        update_diary_entries(data_holder)
        update_diary_tags(data_holder)
      end
    end


    def collect_diary_by_id(id)
      target_diary = @database.execute <<~SQL
        SELECT * FROM diary_entries WHERE id = #{id}
      SQL
      return nil if target_diary.empty?

      DataHolder.create_from_database(target_diary[0])
    end


    def results_as_array
      raise ArgumentError unless block_given?

      @database.results_as_hash = false
      yield
      @database.results_as_hash = true
    end
  end
end
