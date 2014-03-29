require 'spec_helper'

describe "Creating a new user" do

  it "creates a new user" do
    visit root_path

    expect(page).to have_link("Sign Up", :href => new_user_path)
    click_link "Sign Up"

    expect(current_path).to eq(new_user_path)
    fill_in "Name", :with => "Francois"
    fill_in "Username", :with => "franck"
    fill_in "Email", :with => "francois@malinowski.com"
    fill_in "Password", :with => "my_password1"
    fill_in "Password confirmation", :with => "my_password1"

    click_button "Create User"

    last_user = User.last
    expect(last_user.name).to eq("Francois")
    expect(last_user.authenticate("my_password1")).to be_true

    expect(current_path).to eq(user_path(last_user))

    expect(page).to have_text("Francois")
    expect(page).to have_text("franck")
    expect(page).to have_text("Your account was successfully created!")
  end

  it "doesn't create an user if validations are not respected" do
    visit new_user_path

    fill_in "Name", :with => "Francois"
    fill_in "Username", :with => "franck"
    fill_in "Email", :with => "francois@malinowski.com"
    fill_in "Password", :with => "my_passwo"
    fill_in "Password confirmation", :with => "my_passwo"

    expect {
      click_button "Create User"
    }.not_to change(User, :count)

    expect(page).to have_text("The user could not be saved.")
    expect(page).to have_text("Password is too short (minimum is 10 characters)")

  end
end