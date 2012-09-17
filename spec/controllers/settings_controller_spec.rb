require 'spec_helper'

describe SettingsController do

  describe "GET 'twitter_posting'" do
    it "returns http success" do
      get 'twitter_posting'
      response.should be_success
    end
  end

end
