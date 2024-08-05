module RoughDiary
  module Config
    EDITOR = 'vim'

    SAVEDATA_DIR = '~/.diary/article'

    DEFAULT_DIARY_TITLE = 'note'

    DATABASE_PATH = '~/.diary/database.sqlite3'

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
