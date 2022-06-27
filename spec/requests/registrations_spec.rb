require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:existing_user) { create(:user, password: 'password') }

  describe "GET /users/sign_up" do
    before do
      visit new_user_registration_path

      expect(page).to have_content('Register with your personal email')
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
      expect(page).to have_content('Password confirmation')
    end

    describe "Successful" do
      it "should register user successfully after filling the form" do
        fill_in 'user_email', with: 'email@example.com'
        fill_in 'user_password',  with: 'password'
        fill_in 'Password confirmation',  with: 'password'

        click_on('Join us')

        expect(page).to have_content("We are MENA Devs")
      end
    end

    describe "Fails registration" do
      before(:each) do
        visit new_user_registration_path
      end

      it "email already exists" do
        fill_in 'Email', with: existing_user.email
        fill_in 'Password',  with: 'password'
        fill_in 'Password confirmation',  with: 'password'

        click_on('Join us')

        expect(page).to have_content("1 error prohibited this user from being saved")
        expect(page).to have_content("Email has already been taken")
      end

      it "passwords do not match" do
        fill_in 'Email', with: 'mars@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'passwordz'

        click_on('Join us')

        expect(page).to have_content("1 error prohibited this user from being saved")
        expect(page).to have_content("Password confirmation doesn't match Password")
      end


      it "email address is incorrect" do
        fill_in 'Email', with: 'mars-example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'

        click_on('Join us')

        expect(page).to have_content("2 errors prohibited this user from being saved")
        expect(page).to have_content("Email is invalid")
      end

      it "email address contains uncommon number of characters" do
        fill_in 'Email', with: 'xa.z.e.rco@gmail.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'

        click_on('Join us')

        expect(page).to have_content("1 error prohibited this user from being saved")
        expect(page).to have_content("must contain fewer dots")
      end

      it "email address handle ends with a dot" do
        fill_in 'Email', with: 'something-new.@gmail.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'

        click_on('Join us')

        expect(page).to have_content("1 error prohibited this user from being saved")
        expect(page).to have_content("must not end with a dot")
      end
    end
  end
end