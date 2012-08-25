require 'spec_helper'

describe RobotController do

  describe "GET 'dashboard'" do
    it "returns http success" do
      get 'dashboard'
      response.should be_success
    end
  end

  describe "GET 'history'" do
    it "returns http success" do
      get 'history'
      response.should be_success
    end
  end

end
