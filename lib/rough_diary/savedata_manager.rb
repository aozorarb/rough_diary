require 'yaml/store'

module RoughDiary
  module SavedataManager
    class Base
      attr_reader :file_path

      def initialize(savedata_dir, *args)
        @savedata_dir = savedata_dir
        @data = {}

        data_assign(*args)
      end


      def get(key)
        if @data.key?(key)
          @data[key]
        else
          raise ArgumentError, "Invalid key for savedata: #{key}"
        end
      end

      def data_id=(val) = @data[:id] = val


      private def make_file_path
        FileUtils.mkpath(@savedata_dir)
      end 


      private def data_valid?
        @data.all? {|val| val }
      end


      def create_savefile_path
        check_data_validation
        make_file_path
        # FIXME: delete TEST_ keyword when project complete
        @file_path = "#{@savedata_dir}/TEST_#{Time.now.strftime('%Y%m%d%H%M%S')}.yml"

        @called_create_savefile = true
      end


      def save
        raise ScriptError, 'First, exec SavedataManager#create_savefile' unless @called_create_savefile

        store = YAML::Store.new(@file_path)
        save_transaction(store)
        @data
      end


      private def save_transaction = raise NotImplementedError
      private def data_assign = raise NotImplementedError
      def database_format = raise NotImplementedError

    end



    class Normal < Base
      private def data_assign
        @data[:id]          = nil
        @data[:type]        = :normal
        @data[:create_date] = Time.now
        @data[:title]       = RoughDiary::Config::DEFAULT_DIARY_TITLE
        @data[:content]     = nil
      end


      def data_content=(val) = @data[:content] = val
      def data_follow_diary=(val) = @data[:follow_diary] = val
      def data_title=(val) = @data[:title] = val


      private def save_transaction(store)
        # Keep this saving method for redundancy, don't refactor to use @data.each
        store.transaction do
          store['id']           = @data[:id]
          store['type']         = @data[:type]
          store['title']        = @data[:title]
          store['create_date']  = @data[:create_date]
          store['content']      = @data[:content]
        end
      end


      def database_format
        formated_savedata = Data.define(
          :title, :create_date, :type, :follow_diary
        )

        return_savedata = formated_savedata.new(
          title:        @data[:title].to_s,
          create_date:  @data[:create_date].getutc.strftime('%Y-%m-%d %H:%M:%S'),
          type:         @data[:type].to_s,
          follow_diary: @data[:follow_diary].to_s
        )
        return_savedata
      end

    end



    class Fix < Base
      def data_assign(follow_diary)
        @data[:id]            = nil
        @data[:type]          = :fix
        @data[:create_date]   = Time.now
        @data[:follow_diary]  = follow_diary
        @data[:edit_content]  = nil
      end


      def data_edit_content=(val) = @data[:edit_content] = val


      private def save_transaction(store)
        store.transaction do
          store['id']           = @data[:id]
          store['type']         = @data[:type]
          store['create_date']  = @data[:create_date]
          store['follow_diary'] = @data[:follow_diary]
          store['edit_content'] = @data[:edit_content]
        end
      end


      def database_format
        formated_savedata = Data.define(
          :type, :create_date, :follow_diary, :edit_content
        )

        return_savedata = formated_savedata.new(
          type:         @data[:type].to_s,
          create_date:  @data[:create_date].getutc.strftime('%Y-%m-%d %H:%M:%S'),
          follow_diary: @data[:follow_diary],
          edit_content: @data[:edit_content].to_s
        )
        return_savedata
      end

    end
  end
