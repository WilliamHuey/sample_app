require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.should_not change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end

  describe "micropost delete links" do
    let(:user2) { 2.times { FactoryGirl.create(:micropost, user: user) } }

    describe "as current user" do
      it "should not have delete link visible for others" do
        page.should_not have_selector('a', href: user_path(user2), text: 'delete')
      end
    end
  end

  describe "micropost count" do

    describe "as 1 post" do
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        #sign_in user
        visit root_path
      end
      it "should not pluralize single post" do
        page.should have_content("1 micropost")
      end
    end

    describe "as 2 posts" do
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        visit root_path
      end
      it "should pluralize second post" do
        page.should have_content("2 microposts")
      end
    end
  end

  describe "micropost pagination" do
    before { 40.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") } }

    it "should list each micropost" do
      Micropost.all[0..2].each do |micropost|
        page.should have_selector('li', content: micropost.content)
      end
    end

    it "should list the first page of microposts" do
      page.should have_selector('a', href: "/?page=1")
    end

    it "should list the second page of microposts" do
      #puts Micropost.all
      page.should have_selector('a', href: "/?page=2")
    end
  end
end
