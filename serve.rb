require 'sinatra'
require 'haml'
require 'yaml'
require 'tex/hyphen/language'
require 'tex/hyphen/texlive'
require 'bcp47'

include TeX::Hyphen
include TeXLive
include BCP47

get '/' do
  haml :index
end

class Language
  def name
    case @bcp47
    when 'grc-x-ibycus'
      "Ancient Greek"
    when 'sh-cyrl'
      "Serbian"
    else
      code = iso639
      code = Registry.subtags[code].macrolanguage while Registry.subtags[code].macrolanguage
      Registry[code].descriptions.first
    end
  end
end

get '/tex' do
  @packages = Language.all_by_iso639.sort { |a, b| a.last.first.name <=> b.last.first.name }
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
