require 'spec_helper'

describe "Hyphenation.org Sinatra application" do
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

  it "can hyphenate words" do
    # Doesn’t work
    # post '/test-patterns', { 'bcp47' => 'af', 'word' => 'aardvark' }
    # expect(last_response.body).to have_content 'aardvark'
    # expect(last_response.body).to have_css '#hyphenated'#, 'aard-vark'
    visit '/test-patterns'
    fill_in 'word', with: 'aardvark'
    select 'af'
    click_on 'hyphenate'
    # expect(page).to have_content 'Test our patterns'
    expect(page).to have_css '#hyphenated', text: 'aard-vark'
  end
end
