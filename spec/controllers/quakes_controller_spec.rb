require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe QuakesController do
  render_views

  describe "GET index.json" do
    before :each do
      @q1 = FactoryGirl.create(:quake)
      @q2 = FactoryGirl.create(:quake, datetime: Time.at(0))
      @q3 = FactoryGirl.create(:quake, datetime: Time.at(1000), magnitude:1.5)
      @q3 = FactoryGirl.create(:quake, datetime: Time.at(1001), magnitude:1.5)
      @q4 = FactoryGirl.create(:quake, latitude: 55, longitude:55, magnitude: 3.0)
    end

    it "should return a list of all the quakes with no params" do
      get :index, format: :json 
      assigns[:quakes].count.should == 5
      response.status.should be(200)
      JSON.parse(response.body).length.should == 5
    end
    #
    # GET /earthquakes.json?since=1364582194
    # Returns earthquakes since the unix timestamp 1364582194
    it "since should return earthquakes since a datetime" do
      get 'index', { format: 'json', since:1000 }
      JSON.parse(response.body).length.should == 4
    end

    # GET /earthquakes.json?on=1364582194
    # Returns earthquakes on the same day (UTC) as the unix timestamp 1364582194
    it "on should return the earthquakes on the same day (UTC) as the unix timestamp given" do
      get 'index', { format: 'json', on: 1000 }
      JSON.parse(response.body).length.should == 3
    end

    it "since + on: should return from day of quake to the end of the day" do
      get 'index', { format: 'json', on:1000, since:1001 }
      JSON.parse(response.body).length.should == 1
    end

    it "since+on should return times = to params[:since]" do
      get 'index', { format: 'json', on:1000, since:1000 }
      JSON.parse(response.body).length.should == 2
    end

    # GET /earthquakes.json?over=3.2
    # Returns earthquakes > 3.2 magnitude
    it "over: should return earthquakes with magintude greater than that given" do
      get 'index', { format: 'json', over: 1.2 }
      JSON.parse(response.body).length.should == 5

      get 'index', { format: 'json', over: 2.8 }
      JSON.parse(response.body).length.should == 1
    end

    # GET /earthquakes.json?near=36.6702,-114.8870
    # Returns all earthquakes within 5 miles of latitude: 36.6702, lng: -114.8870
    it "near: should return all earthquakes within 5 miles of latitude,longitude given" do
      get 'index', { format: 'json', near: "33.2562,-115.5243" }
      quakes = JSON.parse(response.body)
      quakes.length.should == 4
      quakes.each do |q|
        Geocoder::Calculations.distance_between([33.2562,-115.5243], [q['latitude'], q['longitude']]).should <= 5
      end
    end

    # it "near: should not return earthquaks 6 miles out" do
    # TODO: calculate another point via distance at some bearing
    #   get 'index', { format: 'json', near: "33.2562,-115.5243" }
    #   JSON.parse(response.body).length.should == 4
    # end

    it "should accept arbitrary combinations of params" do
      q3 = FactoryGirl.create(:quake, datetime: Time.at(101), magnitude:1.5, 
                              latitude: 54, longitude: 55)

      get 'index', { format: 'json', 
        over: 1.4, 
        on: 1000, 
        near: "#{@q1.latitude},#{@q1.longitude}" 
      }
      debugger
      JSON.parse(response.body).length.should == 2
    end
  end
end
