require 'spec_helper'

describe UsersController do
  render_views;
  
  describe "GET 'new'" do
    it "should be succesfull" do
      get 'new'
      response.should be_success
    end
    
    it "sholud have a right title" do
      get "new"
      response.should have_selector("title", :content => "Sign up")
    end
  end

end
