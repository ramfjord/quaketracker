require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the QuakesHelper. For example:
#
# describe QuakesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe GeoHelper do
  describe "distance" do
    it "calculates the distance between two lats and lons on the earth in miles" do
      helper.distance(33.2562, -115.5243, 38.7469, 144.3949).should be_close(8537.769, 3.0)
    end
  end
end
