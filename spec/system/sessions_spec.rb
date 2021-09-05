require 'rails_helper'

RSpec.describe 'Session', type: :system do
  let!(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'test_password') }

  shared_examples :logged_in do |email, remember_option|
    it do
      user = User.find_by(email: email)
      expect(current_path).to eq "/users/#{user&.id}"
      expect(user.remember_digest.present?).to eq remember_option
      expect(page).not_to have_content 'Log in'
      expect(page).to have_content 'Log out'
    end
  end

  shared_examples :failed_to_log_in do
    it do
      expect(page).to have_content 'Invalid email/password combination'
      expect(current_path).to eq '/login'
      expect(page).to have_content 'Log in'
      expect(page).not_to have_content 'Log out'
    end
  end

  describe '/login' do
    context 'succeed to login' do
      context 'with remember' do
        include_context :login_as_non_admin_user, 'test@example.com', 'test_password', true
        it_behaves_like :logged_in, 'test@example.com', true
      end

      context 'without remember' do
        include_context :login_as_non_admin_user, 'test@example.com', 'test_password', false
        it_behaves_like :logged_in, 'test@example.com', false
      end
    end

    context 'Failed to login' do
      context 'with non existing user' do
        before do
          visit '/login'
          fill_in 'session_email', with: 'non_existing@example.com'
          fill_in 'session_password', with: 'test_password' 
          within('.login_form') { click_on 'Log in' }
        end

        it_behaves_like :failed_to_log_in
      end

      context 'with incorrect password' do
        before do
          visit '/login'
          fill_in 'session_email', with: 'test@example.com'
          fill_in 'session_password', with: 'incorrect_password'
          within('.login_form') { click_on 'Log in' }
        end

        it_behaves_like :failed_to_log_in
      end
    end
  end

  describe '/logout' do
    include_context :login_as_non_admin_user, 'test@example.com', 'test_password', false

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

