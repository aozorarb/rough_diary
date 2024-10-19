include RoughDiary

def setup_helper
  dh1 = DataHolder::Normal.new
  dh1.data_id = 0
  dh1.data_content = 'recollect'

  dh2 = DataHolder::Normal.new
  dh2.data_id = 1
  dh2.data_content = 'recollect lines'

  fix = DiaryDifferenceTracker.track(dh1, dh2)


  binding
end

def setup
  eval('binding.irb', setup_helper)
end
