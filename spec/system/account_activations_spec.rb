require 'rails_helper'

RSpec.describe 'AccountActivations', type: :system do
  describe '/edit' do
    let(:name)                  { 'sample_user' }
    let(:email)                 { 'sample@example.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }
    let(:token)                 { 'aHfu0XVGX2sjf5vmbEji8A' }

    before do
      allow(User).to receive(:new_token).and_return(token)

      # Create new account
      visit '/signup'
      fill_in 'user_name',                  with: name
      fill_in 'user_email',                 with: email
      fill_in 'user_password',              with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_on 'Create account'
    end

    context 'Without activation' do
      it 'not activated' do
        expect(User.find_by(email: email).activated).to eq false
        expect(User.find_by(email: email).activated_at).to eq nil
        expect(User.find_by(email: email).activation_digest).not_to eq nil
      end
    end

    context 'With activation' do
      before { visit "/account_activations/#{token}/edit?email=#{CGI::escape(email)}" }

      it 'activated' do
        user = User.find_by(email: email)
        expect(user.activated).to eq true
        expect(user.activated_at).not_to eq nil
        expect(current_path).to eq "/users/#{user.id}"
      end
    end

    context 'With invalid token' do
      before { visit "/account_activations/invalid_token/edit?email=#{CGI::escape(email)}" }

      it 'not activated' do
        expect(page).to have_content('Invalid activation link')
        expect(current_path).to eq '/'        
      end
    end
  end
end

