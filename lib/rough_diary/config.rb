module RoughDiary
  module Config
    EDITOR = 'vim'

    SAVEDATA_DIR = '~/.diary/article'

    DEFAULT_DIARY_TITLE = 'note'

    DATABASE_PATH = '~/.diary/database.sqlite3'

    VALID_DIARY_TYPE = {
      normal: :normal,
      append: :append,
      fix:    :fix
    }

    NEED_FOLLOW_DIARY_TYPE = {
      append: :append,
      fix:    :fix
    }
  end
end
