require 'spec_helper'

describe "Hyphenation.org Sinatra application" do
  describe "basic tests" do
    it "doesn’t crash on the landing page" do
      get '/'
      expect(last_response).to be_ok
    end

    it "doesn’t crash on the main page" do
      get '/tex'
      expect(last_response).to be_ok
    end

    it "doesn’t crash on the pattern testing page" do
      get '/test-patterns'
      expect(last_response).to be_ok
    end

    it "can post to the pattern testing page" do
      post '/test-patterns', { 'bcp47' => 'af', 'word' => 'aardvark' }
      expect(last_response).to be_ok
    end
  end

  describe "integration tests" do
    include Capybara::DSL

    it "can hyphenate words" do
      visit '/test-patterns'
      fill_in 'word', with: 'aardvark'
      select 'af'
      click_on 'hyphenate'
      expect(page).to have_css '#hyphenated', text: 'aard-vark'
    end
  end
end
