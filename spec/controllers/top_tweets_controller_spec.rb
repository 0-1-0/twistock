require 'spec_helper'

describe TopTweetsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit_tags'" do
    it "returns http success" do
      get 'edit_tags'
      response.should be_success
    end
  end

  describe "GET 'set_tags'" do
    it "returns http success" do
      get 'set_tags'
      response.should be_success
    end
  end

end
