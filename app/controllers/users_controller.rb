class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    @title = "Show"
    @user = User.find(params[:id])
  end

end
