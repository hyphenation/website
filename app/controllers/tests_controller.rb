class TestsController < ApplicationController
  def show
    @word = ''
  end

  def submit
    @word = params['word']
    @bcp47 = params['bcp47']
    language = Language.find_by_bcp47(@bcp47)
    @hyphenated = language.hyphenate(@word)
    @params = params
  end
end
