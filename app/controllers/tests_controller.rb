class TestsController < ApplicationController
  def show
    fetch_languages
    @word = ''
    @bcp47 = nil
  end

  def submit
    fetch_languages
    @word = params['word']
    @bcp47 = params['bcp47']
    language = Language.find_by_bcp47(@bcp47)
    @hyphenated = language.hyphenate(@word)
  end

  private
  def fetch_languages
    @languages = Language.all.sort { |a, b| a.bcp47 <=> b.bcp47 }
  end
end
