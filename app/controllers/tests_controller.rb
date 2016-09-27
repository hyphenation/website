class TestsController < ApplicationController
  def show
    @word = ''
    @languages = Language.all.sort
    @language = nil
  end

  def submit
    @word = params['word']
    @bcp47 = params['bcp47']
    @languages = Language.all.sort
    @language = Language.find_by_bcp47(@bcp47)
    @hyphenated = @language.hyphenate(@word)
    @params = params
  end
end
