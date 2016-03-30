$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'resque/multifail'
require_relative 'fixtures/example_job'
