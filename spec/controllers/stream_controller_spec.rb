require 'spec_helper'

describe StreamController do

  describe "GET 'infoline'" do
    it "returns http success" do
      get 'infoline'
      response.should be_success
    end
  end

end
