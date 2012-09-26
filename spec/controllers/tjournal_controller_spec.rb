require 'spec_helper'

describe TjournalController do

  describe "GET 'top_tweets'" do
    it "returns http success" do
      get 'top_tweets'
      response.should be_success
    end
  end

end
