require 'spec_helper'

include Pages

describe Pages do
  describe '.mainpage' do
    it "doesn’t crash" do
      mainpage
    end
  end
end
