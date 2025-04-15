require 'yaml/store'
require 'time'

module RoughDiary
  class CustomableDataHolder < DataHolder
    def initialize(id, create_date, update_date, title, content)
      @id = id
      @create_date = create_date
      @update_date = update_date
      @title = title
      @content = content
    end

    attr_accessor :id, :create_date, :update_date, :title, :content
  end
end
