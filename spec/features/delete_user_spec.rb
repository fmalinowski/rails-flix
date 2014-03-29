require 'spec_helper'

describe "destroy an user" do

  it "can destroy an existing user" do
    user = User.create!(:name => "Francois", :username => "u", :email => "francois@malinowski.com", :password => "my_password1")

    visit user_path(user)

    expect(page).to have_link("Delete Account", user_path(user))

    expect {
      click_link "Delete Account"
    }.to change(User, :count).by(-1)

    current_url.should == users_url
    expect(page).to have_text "Your account was successfully deleted!"

    expect(page).not_to have_text(user.name)
  end

end