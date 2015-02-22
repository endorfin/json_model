$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'json_model'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'coveralls'
Coveralls.wear!
