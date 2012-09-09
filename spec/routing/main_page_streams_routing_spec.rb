require "spec_helper"

describe MainPageStreamsController do
  describe "routing" do

    it "routes to #index" do
      get("/main_page_streams").should route_to("main_page_streams#index")
    end

    it "routes to #new" do
      get("/main_page_streams/new").should route_to("main_page_streams#new")
    end

    it "routes to #show" do
      get("/main_page_streams/1").should route_to("main_page_streams#show", :id => "1")
    end

    it "routes to #edit" do
      get("/main_page_streams/1/edit").should route_to("main_page_streams#edit", :id => "1")
    end

    it "routes to #create" do
      post("/main_page_streams").should route_to("main_page_streams#create")
    end

    it "routes to #update" do
      put("/main_page_streams/1").should route_to("main_page_streams#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/main_page_streams/1").should route_to("main_page_streams#destroy", :id => "1")
    end

  end
end
