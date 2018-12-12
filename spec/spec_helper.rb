require 'capybara/dsl'
require 'rack/test'

ENV['RACK_ENV'] = "test"

require_relative '../serve'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
  Capybara.app = Sinatra::Application
end

RSpec.configure do |config|
  config.include RSpecMixin
end
