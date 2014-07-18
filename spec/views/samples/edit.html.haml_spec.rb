require 'rails_helper'

RSpec.describe "samples/edit", :type => :view do
  before(:each) do
    # @sample = assign(:sample, Sample.create!(
    #   :name => "MyString",
    #   :description => "MyText",
    #   :source => "MyString",
    #   :creator_id => 1,
    #   :lab_id => 1,
    #   :grant_id => 1,
    #   :collection_location => "MyString",
    #   :collection_latitude => "9.99",
    #   :collection_longitude => "9.99",
    #   :collection_temp => "9.99"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @sample = FactoryGirl.create(:sample)
  end

  it "renders the edit sample form" do
    render

    # assert_select "form[action=?][method=?]", sample_path(@sample), "post" do
    #
    #   assert_select "input#sample_name[name=?]", "sample[name]"
    #
    #   assert_select "textarea#sample_description[name=?]", "sample[description]"
    #
    #   assert_select "input#sample_source[name=?]", "sample[source]"
    #
    #   assert_select "input#sample_creator_id[name=?]", "sample[creator_id]"
    #
    #   assert_select "input#sample_lab_id[name=?]", "sample[lab_id]"
    #
    #   assert_select "input#sample_grant_id[name=?]", "sample[grant_id]"
    #
    #   assert_select "input#sample_collection_location[name=?]", "sample[collection_location]"
    #
    #   assert_select "input#sample_collection_latitude[name=?]", "sample[collection_latitude]"
    #
    #   assert_select "input#sample_collection_longitude[name=?]", "sample[collection_longitude]"
    #
    #   assert_select "input#sample_collection_temp[name=?]", "sample[collection_temp]"
    # end
  end
end
