require 'spec_helper'

describe UsersController do
  render_views;
  
  describe "GET 'show'" do
    before (:each) do
      @user = Factory(:user)
    end
    
    it "should be sucessfull" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "sholud have a right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
     it "sholud include the user's name" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.name)
    end
    
    it "sholud have profile image" do
        get :show, :id => @user
        response.should have_selector("h1>img", :class => "gravatar")
    end
  end
  
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
