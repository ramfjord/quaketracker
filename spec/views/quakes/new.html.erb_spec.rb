require 'spec_helper'

describe "quakes/new" do
  before(:each) do
    assign(:quake, stub_model(Quake).as_new_record)
  end

  it "renders new quake form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", quakes_path, "post" do
    end
  end
end
