require 'sqlite3'
require 'fileutils'
require_relative 'diary_utils'

include RoughDiary

module RoughDiary
  class DatabaseManager
    def initialize(db_path)
      unless File.exist?(db_path)
        FileUtils.mkpath(File.dirname(db_path))
        FileUtils.touch(db_path)
      end

      @database = SQLite3::Database.new(db_path)
      @database.results_as_hash = true
      ObjectSpace.define_finalizer(self, DatabaseManager.db_finalize(@database))

      @manager = nil
      create_database_if_not_exist
    end


    def self.db_finalize(database)
      proc { database&.close }
    end

    
    def manager=(klass)
      @manager = klass.new(@database)
    rescue
      raise ArgumentError, 'Specify DatabaseManager::{Normal, Fix}'
    end


    def method_missing(method, *args)
      @manager&.public_send(method, *args)
    end


    def respond_to_missing?(sym, include_private)
      @manager&.respond_to?(sym) ? true : super
    end


    private def create_database_if_not_exist
      create_database_if_not_exist_normal
      create_database_if_not_exist_fix
    end


    private def create_database_if_not_exist_normal
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


    private def create_database_if_not_exist_fix
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_fixies (
          id INTEGER PRIMARY KEY,  
          create_date TEXT,
          fix_diary_id INTEGER,
          edit_content TEXT
        );
      SQL
    end
    
  end
end



class RoughDiary::DatabaseManager

  class Base
    def initialize(database)
      @database = database
    end


    def data_holder=(val) @data_holder = val end


    private def check_data_holder
      unless @data_holder
        raise InstanceVariableNilError,
        "Please set @data_holder" unless @data_holder
      end
    end


    private def set_data_id_last_inserted
      check_data_holder
      @data_holder.data_id = @database.last_insert_row_id
    end


    def collect_diary_same_id(id)
      target_diary = @database.execute <<~SQL
        SELECT * FROM diary_entries WHERE id == #{id}
      SQL

      normal_data_holder = DataHolder::Normal.new
      normal_data_holder.create_from_database(target_diary[0])

      fix_data_holders = []

      diary_fixies = @database.execute <<~SQL
        SELECT * FROM diary_fixies WHERE fix_diary_id == #{id} ORDER BY create_date
      SQL
      
      diary_fixies.each do |fix|
        fix_data_holder = DataHolder::Fix.new(nil)
        fix_data_holder.create_from_database(fix)
        fix_data_holders << fix_data_holder
      end

      [normal_data_holder, fix_data_holders]
    end


    def register() raise NotImplementedError end

  end



  class Normal < Base

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

      tags = DiaryHandle.tag_collect(@data_holder)

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


    private def insert_diary_fixies
      sql = <<~SQL
        INSERT INTO diary_fixies (
          create_date, fix_diary_id, edit_content
        ) VALUES (
          ?, ?, ?
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
