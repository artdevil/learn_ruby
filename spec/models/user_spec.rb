require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "example user", 
              :email => "exampleuser@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" 
            }
  end
  
  it "should create a new instances given valid atributes" do
    User.create!(@attr)
  end
  
  it "should require name" do
    no_user_name = User.new(@attr.merge(:name => ""))
    no_user_name.should_not be_valid
  end
  
  it "should require email" do
    no_user_email = User.new(@attr.merge(:email => ""))
    no_user_email.should_not be_valid
  end
  
  it "should reject names that too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name ))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[ user@foo.com THE_USER@foo.bar.org first.last@foo.jp ]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address ))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[ user@foo,com user_at_foo.org first.last@foo. ]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address ))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicates email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject duplicates email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password encryption" do
    
    before (:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the password match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the password didn't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email],"wrong pass")
        wrong_password_user.should be_nil
      end
      it "should retun nil for an email address with no user" do
        nonexistent_user = User.authenticate("tes@example.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
    
    
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short password" do
      short = "a" * 5 
      hash = @attr.merge(:password => short, :password_confirmation => short )
        User.new(hash).should_not be_valid
    end
    
    it "should reject long password" do
      long = "a" * 41 
      hash = @attr.merge(:password => long, :password_confirmation => long )
        User.new(hash).should_not be_valid
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

