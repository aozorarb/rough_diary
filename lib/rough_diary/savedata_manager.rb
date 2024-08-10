require 'yaml/store'

module RoughDiary
  class SavedataManager
    def initialize(title: nil, type: :normal)
      title ||= RoughDiary::Config::DEFAULT_DIARY_TITLE

      @data = {}
      @data[:title] = title
      @data[:create_date] = Time.now
      @data[:type] = type if check_data_type(type.to_sym)
      @data[:content] = nil
      @data[:id] = nil
      @data[:follow_diary] = nil
    end


    def get(key)
      if @data.key?(key)
        @data[key]
      else
        raise ArgumentError, "Invalid key for savedata: #{key}"
      end
    end
    

    def content_data=(content_data) @data[:content] = content_data end
    def follow_diary_data=(follow_diary_data) @data[:follow_diary] = follow_diary_data end
    def id_data=(id_data) @data[:id] = id_data end


    private def check_data_type(type)
      if RoughDiary::Config::VALID_DIARY_TYPE[type]
        true
      else
        raise TypeError, 'Invalid diary type'
        false
      end
    end
    
    private def check_data_follow_diray
      need_type = RoughDiary::Config::NEED_FOLLOW_DIARY_TYPE
      if !need_type.key?([@data[:type]]) || @data[:follow_diary]
        true
      else
        raise TypeError, 'Invalid follow_diary'
        false
      end
    end

    private def check_data_validation
      check_data_follow_diray
    end


    private def make_file_path
      FileUtils.mkpath(RoughDiary::Config::SAVEDATA_DIR)
    end 


    def create_savefile_path
      check_data_validation
      make_file_path
      # FIXME: delete TEST_ keyword when project complete
      @file_path = "#{RoughDiary::Config::SAVEDATA_DIR}/TEST_#{Time.now.strftime('%Y%m%d%H%M%S')}.yml"

      @called_create_savefile = true
    end


    def save
      raise 'First, exec SavedataManager#create_savefile' unless @called_create_savefile

      store = YAML::Store.new(@file_path)
      
      # Keep this saving method for redundancy, don't refactor to use @data.each
      store.transaction do
        store['id'] = @data[:id]
        store['title'] = @data[:title]
        store['create_date'] = @data[:create_date]
        store['content'] = @data[:content]
        store['follow_diary'] = @data[:follow_diary]
      end

    end

    attr_reader :file_path


    def database_format
      formated_savedata = Data.define(
        :title, :create_date, :type, :follow_diary
      )

      return_savedata = formated_savedata.new(
        title: @data[:title].to_s,
        create_date: @data[:create_date].getutc.strftime('%Y-%m-%d %H:%M:%S'),
        type: @data[:type].to_s,
        follow_diary: @data[:follow_diary].to_s
      )
      return_savedata
    end

  end
end
