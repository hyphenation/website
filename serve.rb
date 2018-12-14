require 'sinatra'
require 'byebug'
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
    case @bcp47
    when 'no'
      "Norwegian"
    when 'nb'
      "Norwegian"
    when 'nn'
      "Norwegian"
    when 'cu'
      "Church Slavonic"
    when 'la-x-classic'
      "Latin"
    when 'fa'
      "Persian"
    when 'grc-x-ibycus'
      "Ancient Greek"
    when 'sh-cyrl'
      "Serbian"
    when 'hsb'
      "Upper Sorbian"
    when 'en-us'
      "English"
    else
      babelname
    end
  end
end

get '/tex' do
  @packages = Language.all_by_iso639.sort { |a, b| byebug; a.last.first.dirtyname <=> b.last.first.dirtyname }
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
