require "spec_helper"

describe "viewing a list of users" do

  before(:each) do
    @user_1 = User.create!(:name => "user 1", :username => "u1", :email => "user1@email.com", :password => "password10")
    @user_2 = User.create!(:name => "user 2", :username => "u2", :email => "user2@email.com", :password => "password20")
    @user_3 = User.create!(:name => "user 3", :username => "u3", :email => "user3@email.com", :password => "password30")

    visit users_path
  end

  it "shows the lists of users" do
    expect(page).to have_link(@user_1.name, :href => user_path(@user_1))
    expect(page).to have_link(@user_2.name, :href => user_path(@user_2))
    expect(page).to have_link(@user_3.name, :href => user_path(@user_3))
  end

  it "displays the user page of the user we have clicked on" do
    click_link @user_2.name
    current_url.should == user_url(@user_2)
  end
end