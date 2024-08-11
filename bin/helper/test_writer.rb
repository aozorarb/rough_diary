include RoughDiary

def setup_helper
  savedata = SavedataManager.new('resource/article')
  database = DatabaseManager.new('test.db')
  database.savedata_manager = savedata
  writer = Writer.new(database)
  binding
end

def setup
  eval('binding.irb', setup_helper)
end
