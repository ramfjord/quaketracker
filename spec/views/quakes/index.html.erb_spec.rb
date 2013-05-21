require 'spec_helper'

describe "quakes/index" do
  before(:each) do
    assign(:quakes, [
      stub_model(Quake),
      stub_model(Quake)
    ])
  end

  it "renders a list of quakes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
