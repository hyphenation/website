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
    return 'Ethiopic' if @bcp47 == 'mul-ethi'
    code = iso639

    case code
    when 'hr'
      "Croatian"
    when 'sh'
      "Serbian"
    else
      code = Registry.subtags[code].macrolanguage while Registry.subtags[code].macrolanguage
      Registry[code].descriptions.first.gsub /\s*\(.*\)\s*$/, ''
    end
  end
end

get '/tex' do
  @packages = Language.all_by_iso639
  ['nb', 'nn'].each { |bcp47| @packages['no'] += @packages.delete(bcp47) }
  @packages = @packages.sort { |a, b| Registry[a.first].descriptions.first <=> Registry[b.first].descriptions.first }
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
