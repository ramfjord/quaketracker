require 'spec_helper'

describe "quakes/edit" do
  before(:each) do
    @quake = assign(:quake, stub_model(Quake))
  end

  it "renders the edit quake form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", quake_path(@quake), "post" do
    end
  end
end
