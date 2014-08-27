require 'spec_helper'

describe "pages/edit" do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      :title => "MyString",
      :body => "MyText",
      :tag => "MyString",
      :user_name => "MyString"
    ))
  end

  it "renders the edit page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", page_path(@page), "post" do
      assert_select "input#page_title[name=?]", "page[title]"
      assert_select "textarea#page_body[name=?]", "page[body]"
      assert_select "input#page_tag[name=?]", "page[tag]"
      assert_select "input#page_user_name[name=?]", "page[user_name]"
    end
  end
end
