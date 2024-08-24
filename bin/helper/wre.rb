include RoughDiary

def setup_helper
  data_holder = DataHolder::Normal.new
  database = DatabaseManager.new('test.db')
  database.data_holder = data_holder
  database.manager = DatabaseManager::Normal

  switch_normal = proc { database.manager = DatabaseManager::Normal }
  switch_fix    = proc { database_manager = DatabaseManager::Fix }

  db = database.instance_variable_get(:@manager).instance_variable_get(:@database)

  writer = Writer.new(database, data_holder: data_holder)

  editor = nil
  edit_data_holder = nil
  create_editor = lambda do |follow_id|
    switch_fix.call
    edit_data_holder = DataHolder::Fix.new(follow_id)
    editor = Editor.new(database, follow_id, data_holder: edit_data_holder)
  end



  binding
end

def setup
  eval('binding.irb', setup_helper)
end
