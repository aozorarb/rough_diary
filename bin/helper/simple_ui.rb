include RoughDiary
include SimpleUi
def setup_helper
  core = SimpleUi::Core.new

  db_manager = core.instance_variable_get(:@db_manager)

  binding
end

def setup
  eval('binding.irb', setup_helper)
end
