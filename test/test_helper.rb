require 'simplecov'
SimpleCov.start do
  add_filter "/test"
  add_filter "/lib"
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
I18n.enforce_available_locales = false
require 'rails/test_help'
require 'minitest/pride'

# add the root to the load path
$LOAD_PATH.unshift File.expand_path '../..', __FILE__
require 'test/helpers/controller'
require 'test/helpers/feature'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
