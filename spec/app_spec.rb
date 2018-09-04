require 'spec_helper'

describe "Hyphenation.org Sinatra application" do
  it "doesn’t crash on the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "doesn’t crash on the main page" do
    get '/tex'
    expect(last_response).to be_ok
  end
end
