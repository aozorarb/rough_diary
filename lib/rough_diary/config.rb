module RoughDiary
  module Config
    EDITOR = 'vim'

    SAVEDATA_DIR = '~/.diary'

    DEFAULT_DIARY_TITLE = 'note'

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
