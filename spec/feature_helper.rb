$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
require "capybara/rails"
require "capybara/rspec"

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
end
