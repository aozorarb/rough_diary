# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

Kernel.module_exec do
  alias_method :v_get ,:instance_variable_get
  alias_method :v_set ,:instance_variable_set
end

require 'rough_diary'
require 'simple_ui'
require 'configatron'
require 'debug'
require 'minitest/mock'
require "minitest/autorun"
