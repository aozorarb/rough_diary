# frozen_string_literal: true

require_relative 'rough_diary/core'


module RoughDiary
  def self.run
    core = RoughDiary::Core.new
    core.run
  end

end


# pp RoughDiary.public_methods(false)
RoughDiary.run
