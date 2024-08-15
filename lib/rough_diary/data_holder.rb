require 'yaml/store'

module RoughDiary
  module DataHolder
    class Base

      def initialize(*args)
        @data = {}

        data_assign(*args)
      end


      def get(key)
        if @data.key?(key)
          @data[key]
        else
          raise ArgumentError, "Invalid key for DataHolder: #{key}"
        end
      end


      def data_id=(val) = @data[:id] = val


      private def data_valid?
        @data.all? {|val| val }
      end


      private def data_assign = raise NotImplementedError
      def database_format = raise NotImplementedError

    end



    class Normal < Base
      private def data_assign
        @data[:id]          = nil
        @data[:create_date] = Time.now
        @data[:title]       = RoughDiary::Config::DEFAULT_DIARY_TITLE
        @data[:content]     = nil
      end


      def data_content=(val) = @data[:content] = val
      def data_title=(val) = @data[:title] = val


      def database_format
        formated_data = Data.define(
          :create_date, :title, :content
        )

        return_data = formated_data.new(
          create_date:  @data[:create_date].getutc.strftime('%Y-%m-%d %H:%M:%S'),
          title:        @data[:title].to_s,
          content:      @data[:content].to_s
        )
        return_data
      end

    end



    class Fix < Base
      def data_assign(follow_diary)
        @data[:id]            = nil
        @data[:create_date]   = Time.now
        @data[:follow_diary]  = follow_diary
        @data[:edit_content]  = nil
      end


      def data_edit_content=(val) = @data[:edit_content] = val


      def database_format
        formated_savedata = Data.define(
          :create_date, :follow_diary, :edit_content
        )

        return_savedata = formated_savedata.new(
          create_date:  @data[:create_date].getutc.strftime('%Y-%m-%d %H:%M:%S'),
          follow_diary: @data[:follow_diary].to_i
          edit_content: @data[:edit_content].to_s
        )
        return_savedata
      end

    end
  end
