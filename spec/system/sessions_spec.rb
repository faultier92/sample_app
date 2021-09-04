require 'rails_helper'

RSpec.describe 'Session', type: :system do
  let(:email)    { 'sample@example.com' }
  let(:password) { 'sample_password' }
  let!(:user)    { FactoryBot.create(:user, email: email, password: password) }
  let(:current_user) { instance_variable_get(:@current_user) }

  describe '/login' do
    before { visit '/login' }

    context 'Succeed to login' do
      shared_examples 'redirect to user detail page' do
        it do
          expect(current_path).to eq "/users/#{user.id}"
          expect(page).not_to have_content 'Log in'
          expect(page).to have_content 'Log out'
        end
      end

      context 'with correct email and password' do
        before do
          fill_in 'session_email', with: email
          fill_in 'session_password', with: password
          within('.login_form') { click_on 'Log in' }
        end

        it_behaves_like 'redirect to user detail page'
      end
    end

    context 'Failed to login' do
      shared_examples 'back to login page and display alert' do
        it do
          expect(page).to have_content 'Invalid email/password combination'
          expect(current_path).to eq '/login'
          expect(page).to have_content 'Log in'
          expect(page).not_to have_content 'Log out'
        end
      end

      context 'with non existing user' do
        before do
          fill_in 'session_email', with: 'not_exist@example.com'
          fill_in 'session_password', with: password
          within('.login_form') { click_on 'Log in' }
        end

        it_behaves_like 'back to login page and display alert'
      end

      context 'with incorrect password' do
        before do
          fill_in 'session_email', with: email
          fill_in 'session_password', with: 'incorrect' + password
          within('.login_form') { click_on 'Log in' }
        end

        it_behaves_like 'back to login page and display alert'
      end
    end
  end

  describe '/logout' do
    before do
      visit '/login'
      fill_in 'session_email', with: email
      fill_in 'session_password', with: password
      within('.login_form') { click_on 'Log in' }
    end

    context 'when successfully logged out' do
      before { click_on 'Log out'  }

      it 'redirect to root path' do
        expect(current_path).to eq '/'
        expect(page).to have_content 'Log in'
        expect(page).not_to have_content 'Log out'
      end
    end
  end
end

