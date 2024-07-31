require 'yaml/store'

module RoughDiary
  class SavedataManager
    def initialize(title: nil, type: normal)
      title ||= RoughDiary::Config::DEFAULT_DIARY_TITLE

      @data = {}
      @data[:title] = title
      @data[:create_date] = Time.now
      @data[:type] = type if check_type(type.to_sym)
      @data[:content] = nil
      @data[:id] = nil
      @data[:follow_diary] = nil
    end

    
    def content_data=(content_data) @data[:content] = content_data end
    def follow_diary_data=(follow_diary_data) @data[:follow_diary] = follow_diary_data end
    def id_data=(id_data) @data[:id] = id_data end


    private def check_type(type)
      if RoughDiary::Config::VALID_DIARY_TYPE[type]
        true
      else
        raise TypeError, 'Invalid diary type'
        false
      end
    end

    private def check_data_follow_diray
      need_type = RoughDiary::Config::NEED_FOLLOW_DIARY_TYPE
      if need_type[@data[:type]]
        true
      else
        raise TypeError, 'Invalid follow_diary'
        false
      end
    end

    private def check_data_validation
      check_data_type
      check_data_follow_diray
    end


    def save
      check_data_validation
      file_path = "#{RoughDiary::Config::SAVEDATA_DIR}/#{Time.now.strftime('%Y%m%d%H%M%S')}"
      store = YAML::Store.new(file_path)

      # Keep this saving method for redundancy, don't refactor to use @data.each
      store.transaction do
        store['id'] = @data[:id]
        store['title'] = @data[:title]
        store['create_data'] = @data[:create_data]
        store['content'] = @data[:content]
        store['follow_diary'] = @date[:follow_diary]
      end
    end

  end
end
