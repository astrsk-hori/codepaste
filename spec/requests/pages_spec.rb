require 'spec_helper'

describe "Pages" do
  let(:user){ FactoryGirl.create(:user)}
  before do
    #login_user user
  end
  describe "GET /pages" do
    it "works! (now write some real specs)" do
      pending("request spec のテストはとりあえずなし")
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pages_path
      response.status.should be(200)
    end
  end
end
