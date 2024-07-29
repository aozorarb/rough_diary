require_relative 'diary_content_generator'

module RoughDiary
  class Writer
    def init
      @database = Database.new
      @config = Config.new
    end

    
    def create_savedata
    end

    
    def generate_diary_content

    end

    
    def register_database

    end

    
    def diary_write
      raise NotImplementedError
      init
      create_savedata
      generate_diary_content
      regist_database
    end
  end
end

