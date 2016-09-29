require 'sinatra'
require File.expand_path('../../../lib/hyphwebsite', __FILE__)

class Application < Sinatra::Application
  def self.call(ignore)
  end

  private
end
