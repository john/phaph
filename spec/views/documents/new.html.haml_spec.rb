require 'rails_helper'

RSpec.describe "documents/new", :type => :view do
  before(:each) do
    # assign(:paper, document.new(
    #   :name => "MyString",
    #   :description => "MyText",
    #   :source => "MyString",
    #   :journal => "MyString",
    #   :principle_author => "MyString",
    #   :other_authors => "MyString",
    #   :rights => "MyString",
    #   :creator_id => 1,
    #   :lab_id => 1,
    #   :grant_id => 1,
    #   :state => "MyString"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @document = FactoryGirl.create(:document)
  end

  it "renders" do
    render
    #
    # assert_select "form[action=?][method=?]", papers_path, "post" do
    #
    #   assert_select "input#paper_name[name=?]", "paper[name]"
    #
    #   assert_select "textarea#paper_description[name=?]", "paper[description]"
    #
    #   assert_select "input#paper_source[name=?]", "paper[source]"
    #
    #   assert_select "input#paper_journal[name=?]", "paper[journal]"
    #
    #   assert_select "input#paper_principle_author[name=?]", "paper[principle_author]"
    #
    #   assert_select "input#paper_other_authors[name=?]", "paper[other_authors]"
    #
    #   assert_select "input#paper_rights[name=?]", "paper[rights]"
    #
    #   assert_select "input#paper_creator_id[name=?]", "paper[creator_id]"
    #
    #   assert_select "input#paper_lab_id[name=?]", "paper[lab_id]"
    #
    #   assert_select "input#paper_grant_id[name=?]", "paper[grant_id]"
    #
    #   assert_select "input#paper_state[name=?]", "paper[state]"
    # end
  end
end