require "spec_helper"

describe QuakesController do
  describe "routing" do

    it "routes to #index" do
      get("/quakes").should route_to("quakes#index")
    end

    it "routes to #new" do
      get("/quakes/new").should route_to("quakes#new")
    end

    it "routes to #show" do
      get("/quakes/1").should route_to("quakes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/quakes/1/edit").should route_to("quakes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/quakes").should route_to("quakes#create")
    end

    it "routes to #update" do
      put("/quakes/1").should route_to("quakes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/quakes/1").should route_to("quakes#destroy", :id => "1")
    end

  end
end
