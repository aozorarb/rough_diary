require_relative 'diary_content_generator'

module RoughDiary
  class Writer
    def initialize
    end

    
    def create_savedata
    end

    
    def generate_diary_content

    end

    
    def register_database

    end

    
    def write
      raise NotImplementedError
      create_savedata
      generate_diary_content
      register_database
    end
  end
end

