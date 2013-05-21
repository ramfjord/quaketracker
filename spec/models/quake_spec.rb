require 'csv'
require 'spec_helper'

describe Quake do
  it "should have valid factory" do
    FactoryGirl.build(:quake).should be_valid
  end

  it "should require latitude, longitude and datetime" do
    FactoryGirl.build(:quake, :latitude => nil).should_not be_valid
    FactoryGirl.build(:quake, :longitude => nil).should_not be_valid
    FactoryGirl.build(:quake, :datetime => nil).should_not be_valid
  end

  it "should not allow two earthquakes in the same time and space" do
    q1 = FactoryGirl.create(:quake)
    q2 = FactoryGirl.build(:quake)
    q2.should_not be_valid
  end

  describe "special queries" do
    before :each do
      @q1 = FactoryGirl.create(:quake)
      @q2 = FactoryGirl.create(:quake, datetime: Time.at(0))
      @q3 = FactoryGirl.create(:quake, datetime: Time.at(1000))
      @q3 = FactoryGirl.create(:quake, datetime: Time.at(1001))
      @q4 = FactoryGirl.create(:quake, latitude: 55, longitude:55, magnitude: 3.0)
    end

    # GET /earthquakes.json?since=1364582194
    # Returns earthquakes since the unix timestamp 1364582194
    it "since should return earthquakes since a datetime" do
      Quake.since(1000).count.should == 4
    end

    # GET /earthquakes.json?on=1364582194
    # Returns earthquakes on the same day (UTC) as the unix timestamp 1364582194
    it "on should return the earthquakes on the same day (UTC) as the unix timestamp given" do
      Quake.on(1000).count.should == 3
    end

    it "since + on: should return from day of quake to the end of the day" do
      Quake.on(1000).since(1001).count.should == 1
      Quake.on(1000).since(999).count.should == 2
    end

    # GET /earthquakes.json?over=3.2
    # Returns earthquakes > 3.2 magnitude
    it "over: should return earthquakes with magintude greater than that given" do
      Quake.over(1.2).count.should == 5
      Quake.over(2.9).count.should == 1
    end

    # GET /earthquakes.json?near=36.6702,-114.8870
    # Returns all earthquakes within 5 miles of latitude: 36.6702, lng: -114.8870
    it "near: should return all earthquakes within 5 miles of latitude,longitude given" do
      Quake.near5(33.2562, -115.5243).count.should == 4
      Quake.near5(55, 55.001).count.should == 1
    end
  end

  describe "load_from_csv" do
    before :each do
      csv_s = [
"Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region",
"ci,15343569,2,\"Thursday, May 16, 2013 08:49:30 UTC\",33.2562,-115.5243,1.3,1.00,12,\"Southern California\"",
"us,b000gwvx,5,\"Thursday, May 16, 2013 08:03:51 UTC\",38.7469,144.3949,4.5,35.00,40,\"off the east coast of Honshu, Japan\"",
"ak,10717982,1,\"Thursday, May 16, 2013 07:55:21 UTC\",59.9753,-141.6623,1.5,19.20, 8,\"Southeastern Alaska\"",
"ci,15343545,2,\"Thursday, May 16, 2013 07:53:37 UTC\",33.2807,-116.7775,1.1,14.40,34,\"Southern California\"",
"us,b000gwvq,5,\"Thursday, May 16, 2013 07:39:51 UTC\",37.1110,141.2358,4.5,35.00,22,\"near the east coast of Honshu, Japan\"",
"nc,71992306,0,\"Thursday, May 16, 2013 07:31:28 UTC\",36.5358,-121.1205,1.7,3.30,14,\"Central California\""
      ].join("\n")

      @q1 = FactoryGirl.create(:quake)
      @q2 = FactoryGirl.create(:quake, datetime: Time.at(0))
      @q3 = FactoryGirl.create(:quake, datetime: Time.at(1000))
      @csv = CSV.parse csv_s
    end

    it "should read in a csv which includes at least magnitude, lat, lon, and datetime" do
      Quake.get_all_from_csv(@csv)
      Quake.count.should == 9
    end

    it "update should only check until we reach a time we've already loaded" do
      FactoryGirl.create(:quake, datetime: "Thursday, May 16, 2013 08:05:51 UTC")
      Quake.update_from_csv(@csv)
      Quake.count.should == 5
    end
  end
end
