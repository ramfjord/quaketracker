require 'spec_helper'

describe "quakes/show" do
  before(:each) do
    @quake = assign(:quake, stub_model(Quake))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
