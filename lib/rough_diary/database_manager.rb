require 'sqlite3'

module RoughDiary
  class DatabaseManager
    def initialize(file_name)
      @database = SQLite3::Database.new(file_name)
      create_database_if_not_exist

      ObjectSpace.define_finalizer(self, self.finalize(@database))
    end


    def self.finalize(database)
      proc { database.&close }
    end


    def create_database_if_not_exist
      # mainly database
      @database.execute <<~SQL
        CREATE TABLE IF NOT EXISTS diary_entries (
          id INTEGER PRIMARY KEY,
          diary_path TEXT,
          title TEXT,
          create_data TEXT
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
    end

  end
end

