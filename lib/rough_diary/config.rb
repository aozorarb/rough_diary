module RoughDiary
  module Config
    EDITOR = 'vim'

    PAGER = 'less'

    SAVEDATA_DIR = File.expand_path('~/.diary/article')

    DEFAULT_DIARY_TITLE = 'note'

    DATABASE_PATH = File.expand_path('~/.diary/database.sqlite3')

    VALID_DIARY_TYPE = {
      normal: true,
      fix:    true,
    }

    NEED_FOLLOW_DIARY_TYPE = {
      fix:    true,
    }

  end
end


