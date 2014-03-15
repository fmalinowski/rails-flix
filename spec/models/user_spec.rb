require 'spec_helper'

describe "A User" do

  it "must have a name" do
    user_without_name = User.new(:name => "", :email => "me@email.com", :password => "some_password")

    expect(user_without_name.valid?).to be_false
    expected_errors = ["Name can't be blank"]
    expect(user_without_name.errors.full_messages).to eq(expected_errors)

    user_with_name = User.new(:name => "There's a name", :email => "me@email.com", :password => "some_password")
    expect(user_with_name.valid?).to be_true
  end

  it "can't have an empty email" do
    user_without_email = User.new(:name => "Some name", :email => "", :password => "some_password")

    expect(user_without_email.valid?).to be_false
    expected_errors = ["Email can't be blank", "Email is invalid"]
    expect(user_without_email.errors.full_messages).to eq(expected_errors)

  end

  it "must have a well formatted email" do
    user_with_invalid_email = User.new(:name => "There's a name", :email => "some_inv@lid_email", :password => "some_password")
    expect(user_with_invalid_email.valid?).to be_false
    expected_errors = ["Email is invalid"]
    expect(user_with_invalid_email.errors.full_messages).to eq(expected_errors)

    user_with_valid_email = User.new(:name => "There's a name", :email => "me@email.com", :password => "some_password")
    expect(user_with_valid_email.valid?).to be_true
  end

  it "needs a unique email non sensitive to the case" do
    user_1 = User.create!(:name => "Some name", :email => "me@email.com", :password => "some_password")

    user_2 = User.new(:name => "Some name2", :email => "mE@eMaIl.COm", :password => "some_password2")
    expect(user_2.valid?).to be_false
    expected_errors = ["Email has already been taken"]
    expect(user_2.errors.full_messages).to eq(expected_errors)
  end

  it "needs a password" do
    user = User.new(:name => "Some name", :email => "me@email.com", :password => "")
    expect(user.valid?).to be_false
    expected_errors = ["Password can't be blank"]
    expect(user.errors.full_messages).to eq(expected_errors)
  end

  it "needs a password at least 10 caracters long" do
    user_1 = User.new(:name => "Some name", :email => "me@email.com", :password => "password1")
    expect(user_1.valid?).to be_false
    expected_errors = ["Password is too short (minimum is 10 characters)"]
    expect(user_1.errors.full_messages).to eq(expected_errors)

    user_2 = User.new(:name => "Some name", :email => "me@email.com", :password => "password12")
    expect(user_2.valid?).to be_true
  end

  it "must have the same element in password and password confirmation" do
    user = User.new(:name => "Some name", :email => "me@email.com", :password => "password11",
                      :password_confirmation => "password22")
    expect(user.valid?).to be_false
    expected_errors = ["Password confirmation doesn't match Password"]
    expect(user.errors.full_messages).to eq(expected_errors)

    user.password_confirmation = "password11"
    expect(user.valid?).to be_true
  end

  it "encrypts the password when the password is provided" do
    user = User.new(:name => "Some name", :email => "me@email.com")
    expect(user.password_digest).to be_nil

    user.password = "some_password"
    expect(user.password_digest).not_to be_nil
  end

  it "can modify the other attributes and leaves the password empty" do
    user = User.create!(:name => "Some name", :email => "me@email.com", :password => "my_password", :password_confirmation => "my_password")

    user.name = "Modified name"
    user.password =""

    expect(user.valid?).to be_true
    user.save!
  end
end