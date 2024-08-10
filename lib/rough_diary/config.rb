module RoughDiary
  module Config
    EDITOR = 'vim'

    SAVEDATA_DIR = File.expand_path('~/.diary/article')

    DEFAULT_DIARY_TITLE = 'note'

    DATABASE_PATH = File.expand_path('~/.diary/database.sqlite3')

    VALID_DIARY_TYPE = {
      normal: true,
      append: true,
      fix:    true,
    }

    NEED_FOLLOW_DIARY_TYPE = {
      append: true,
      fix:    true,
    }
  end
end
