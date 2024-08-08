if RoughDiary
  unless RoughDiary::Config.const_defined?(:OVERWRITE)
    
    remove_consts = [
      :DEFAULT_DIARY_TITLE,
      :SAVEDATA_DIR
    ]
    remove_consts.each do |const|
      RoughDiary::Config.send(:remove_const, const)
    end

    module RoughDiary::Config
      OVERWRITE = true
      DEFAULT_DIARY_TITLE = 'default'
      SAVEDATA_DIR = Dir.mktmpdir

    end

  end
end
