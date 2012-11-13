require 'spec_helper'

describe ExchangeController do

  describe "GET 'buy'" do
    it "returns http success" do
      get 'buy'
      response.should be_success
    end
  end

  describe "GET 'sell'" do
    it "returns http success" do
      get 'sell'
      response.should be_success
    end
  end

end
