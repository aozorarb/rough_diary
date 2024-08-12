require 'yaml/store'

module RoughDiary
  class SavedataManager
    def initialize(savedata_dir, type: :normal)
      @savedata_dir = savedata_dir

      @data = {}
      @data[:title] = RoughDiary::Config::DEFAULT_DIARY_TITLE
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
    

    def content_data=(content) @data[:content] = content end
    def follow_diary_data=(follow_diary) @data[:follow_diary] = follow_diary end
    def id_data=(id) @data[:id] = id end
    def title_data=(title) @data[:title] = title end


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
      end
    end

    private def check_data_validation
      check_data_follow_diray
    end


    private def make_file_path
      FileUtils.mkpath(@savedata_dir)
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
      
      # Keep this saving method for redundancy, don't refactor to use @data.each
      store.transaction do
        store['id'] = @data[:id]
        store['title'] = @data[:title]
        store['create_date'] = @data[:create_date]
        store['content'] = @data[:content]
        store['follow_diary'] = @data[:follow_diary]
      end
      @data
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
