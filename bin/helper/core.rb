include RoughDiary

def setup_helper
  core = Core.new

  db_manager = core.instance_variable_get(:@database_manager)
  db = db_manager.instance_variable_get(:@database)

  binding
end

def setup
  eval('binding.irb', setup_helper)
end
