require "spec_helper"

describe "viewing an individual user" do

  it "displays the information about the required user" do
    user_1 = User.create!(:name => "User 1", :username => "u1", :email=> "email1@nothing.com", :password => "MyNicePassword1", :password_confirmation => "MyNicePassword1")
    user_2 = User.create!(:name => "User 2", :username => "u2", :email=> "email2@nothing.com", :password => "MyNicePassword1", :password_confirmation => "MyNicePassword1")

    visit user_path(user_1)

    expect(page).not_to have_text(user_2.name)
    expect(page).not_to have_text(user_2.username)
    expect(page).not_to have_text(user_2.email)

    expect(page).to have_text(user_1.name)
    expect(page).to have_text(user_1.username)
    expect(page).to have_text(user_1.email)
    expect(page).to have_text(user_1.created_at.strftime("%B %Y"))

  end
end