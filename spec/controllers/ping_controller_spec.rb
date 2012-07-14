require 'spec_helper'

describe PingController do

  describe "GET 'pong'" do
    it "returns http success" do
      get 'pong'
      response.should be_success
    end
  end

end
