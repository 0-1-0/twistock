require 'spec_helper'

describe UserController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'set_mail'" do
    it "returns http success" do
      get 'set_mail'
      response.should be_success
    end
  end

  describe "GET 'set_preferences'" do
    it "returns http success" do
      get 'set_preferences'
      response.should be_success
    end
  end

end
