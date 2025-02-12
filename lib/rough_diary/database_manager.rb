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
      @data_holder = nil

      ObjectSpace.define_finalizer(self, DatabaseManager.db_finalize(@database))

      create_database_if_not_exist
    end

    attr_writer :data_holder


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


    private def insert_diary_entries
      sql = <<~SQL
        INSERT INTO diary_entries (
          create_date, update_date, title, content
        ) VALUES (
          ?, ?, ?, ?
        )
      SQL
      data = @data_holder.database_format

      @database.execute sql, [
        data.create_date,
        data.update_date,
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

      tags = DiaryUtils.tag_collect(@data_holder)

      tags.each do |tag|
        @database.execute sql, [
          @data_holder.id,
          tag
        ]
      end
      @database
    end



    private def check_data_holder
      raise InstanceVariableNilError,
            "Please set @data_holder" unless @data_holder
    end


    private def set_data_id_last_inserted
      check_data_holder
      @data_holder.id = @database.last_insert_row_id
    end


    def execute(query)
      @database.execute(
        SQLite3::Database.quote(query)
      )
    end


    def register
      check_data_holder

      @database.transaction do
        insert_diary_entries
        set_data_id_last_inserted
        insert_diary_tags
      end
    end


    def collect_diary_by_id(id)
      target_diary = @database.execute <<~SQL
        SELECT * FROM diary_entries WHERE id = #{id}
      SQL
      
      DataHolder.create_from_database(target_diary[0])
    end
  end
end
