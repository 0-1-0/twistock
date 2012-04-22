require 'spec_helper'

describe WelcomeController do

  describe "GET '/'" do
    it "returns http success" do
      get '/'
      response.should be_success
    end
  end

end
