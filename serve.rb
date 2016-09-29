require 'sinatra'
require File.expand_path('../lib/hyphwebsite/serve', __FILE__)

get '/' do
  erb :index
end

get '/test-patterns' do
  fetch_languages
  @word = ''
  @bcp47 = nil
  haml :show
end

post '/test-patterns' do
  fetch_languages
  @word = params['word']
  @bcp47 = params['bcp47']
  language = Language.find_by_bcp47(@bcp47)
  @hyphenated = language.hyphenate(@word)
  haml :submit
end

def fetch_languages
  @languages = Language.all.sort { |a, b| a.bcp47 <=> b.bcp47 }
end

get '/relicensing' do
  haml :relicensing
end
