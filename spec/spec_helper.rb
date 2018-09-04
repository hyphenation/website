# ENV['RAILS_ENV'] = "test"
# require 'capybara'
require 'capybara/dsl'
# require 'capybara/rspec'
require 'rack/test'
require 'tex/hyphen/patterns'
require_relative '../lib/pages'

ENV['RACK_ENV'] = "test"

require_relative '../serve'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
  Capybara.app = Sinatra::Application
end

include Capybara::DSL

RSpec.configure do |config|
  config.include RSpecMixin
end
