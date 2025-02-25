require 'yaml/store'
require 'time'

module RoughDiary
  class DataHolder
    def initialize
      @id = nil
      @create_date = nil
      @update_date = @create_date
      @title = configatron.system.default_diary_title
      @content = nil
    end

    attr_reader   :create_date, :update_date, :content
    attr_accessor :id, :title


    def self.create_from_database(sql_result)
      data_holder = self.allocate
      sql_res = sql_result.dup
      sql_res['create_date'] = Time.parse(sql_res['create_date'])
      sql_res['update_date'] = Time.parse(sql_res['update_date'])
      sql_res.each do |key, val|
        var = "@#{key}".to_sym
        data_holder.instance_variable_set(var, val)
      end

      data_holder
    end


    def database_format
      formated_data = Data.define(
        :id, :create_date, :update_date, :title, :content
      )

      return_data = formated_data.new(
        id:           @id.to_s,
        create_date:  @create_date.to_s,
        update_date:  @update_date.to_s,
        title:        @title.to_s,
        content:      @content.to_s
      )
      return_data
    end


    def content=(content)
      if @create_date.nil?
        @create_date = @update_date = Time.new
      else
        @update_date = Time.now
      end
      @content = content
    end
  end
end
