require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:notuser) { FactoryGirl.create(:user) }
  let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
  let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
  let!(:m2) { FactoryGirl.create(:micropost, user: notuser, content: "Bar") }
  
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link('delete', match: :first) }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as incorrect user it should not delete micropost" do
      before {visit user_path(User.last)}

      it { should_not have_link('delete') }
      end

    end

    
  end

