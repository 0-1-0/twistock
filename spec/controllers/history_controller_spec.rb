require 'spec_helper'

describe HistoryController do

  describe "GET 'transactions'" do
    it "returns http success" do
      get 'transactions'
      response.should be_success
    end
  end

end
