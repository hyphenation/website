require 'sinatra'
require 'haml'
require 'yaml'
require 'tex/hyphen/language'
require 'tex/hyphen/texlive'

include TeX::Hyphen
include TeXLive

get '/' do
  haml :index
end

class Language
  def dirtyname
  if @bcp47 == 'no'
    "Norwegian"
  elsif @bcp47 == 'la'
    "Latin"
  elsif bcp47 == 'grc'
    "Ancient Greek"
  else
  end
end

get '/tex' do
  @packages = Language.all_by_iso639.sort { |a, b| (a.last.first.babelname || '') <=> (b.last.first.babelname || '') }
  haml :tex
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
  @languages = Language.all.sort
end

get '/relicensing' do
  haml :relicensing
end
