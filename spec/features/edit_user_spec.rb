require 'spec_helper'

describe "Update an existing user" do

  it "can update an existing user without changing the password" do
    user = User.create!(:name => "Francois", :username => "u", :email => "francois@malinowski.com", :password => "my_password1", :password_confirmation => "my_password1")

    visit user_path(user)

    expect(page).to have_link("Edit Account", edit_user_path(user))
    click_link "Edit Account"

    expect(page).to have_xpath("//input[@name='user[name]' and @value='#{user.name}']")
    expect(page).to have_xpath("//input[@name='user[username]' and @value='#{user.username}']")
    expect(page).to have_xpath("//input[@name='user[email]' and @value='#{user.email}']")

    fill_in "Name", :with => "Christophe"
    fill_in "Username", :with => "Chris"
    fill_in "Email", :with => "christophe@malinowski.com"
    click_button "Update User"

    user.reload
    current_url.should == user_url(user)
    expect(page).to have_text "Your account was successfully updated!"
    expect(page).to have_text user.name
    expect(page).to have_text user.username
    expect(page).to have_text user.email

    expect(user.name).to eq("Christophe")
    expect(user.username).to eq("Chris")
    expect(user.email).to eq("christophe@malinowski.com")
  end

  it "can update an existing user with changing the password" do
    user = User.create!(:name => "Francois", :username => "u", :email => "francois@malinowski.com", :password => "my_password1", :password_confirmation => "my_password1")

    visit user_path(user)

    expect(page).to have_link("Edit Account", edit_user_url(user))
    click_link "Edit Account"

    fill_in "Name", :with => "Christophe"
    fill_in "Username", :with => "Chris"
    fill_in "Email", :with => "christophe@malinowski.com"
    fill_in "Password", :with => "my_password2"
    fill_in "Password confirmation", :with => "my_password2"
    click_button "Update User"

    user.reload
    current_url.should == user_url(user)
    expect(page).to have_text "Your account was successfully updated!"
    expect(page).to have_text user.name
    expect(page).to have_text user.username
    expect(page).to have_text user.email

    expect(user.name).to eq("Christophe")
    expect(user.username).to eq("Chris")
    expect(user.email).to eq("christophe@malinowski.com")
    expect(user.authenticate("my_password2")).to be_true
  end

  it "cannot update an existing user if the updated attributes are invalid" do
    user = User.create!(:name => "Francois", :username => "u", :email => "francois@malinowski.com", :password => "my_password1", :password_confirmation => "my_password1")

    visit user_path(user)

    expect(page).to have_link("Edit Account", edit_user_path(user))
    click_link "Edit Account"

    expect(page).to have_text("Edit your Account")
    fill_in "Name", :with => "Christophe"
    fill_in "Username", :with => "Chris"
    fill_in "Email", :with => "christophe@malinowski.com"
    fill_in "Password", :with => "my_passwo"
    fill_in "Password confirmation", :with => "my_passwo"
    click_button "Update User"

    user.reload
    expect(page).to have_text "The user could not be saved."
    expect(page).to have_text "Password is too short (minimum is 10 characters)"

    expect(user.authenticate("my_password1")).to be_true
  end
end