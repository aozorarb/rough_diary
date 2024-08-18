include RoughDiary

def setup_helper
  data_holder = DataHolder::Normal.new
  database = DatabaseManager.new('test.db')
  database.data_holder = data_holder
  database.manager = DatabaseManager::Normal

  db = database.instance_variable_get(:@manager).instance_variable_get(:@database)
  writer = Writer.new(database, data_holder: data_holder)
  binding
end

def setup
  eval('binding.irb', setup_helper)
end
