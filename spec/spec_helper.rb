# ENV['RAILS_ENV'] = "test"
require 'rack/test'
require 'tex/hyphen/patterns'
require_relative '../lib/hyphwebsite'

ENV['RACK_ENV'] = "test"

require_relative '../serve'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
