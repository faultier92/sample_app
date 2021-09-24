require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  let(:email) { 'test@example.com' }
  let!(:user) { FactoryBot.create(:user, email: email) }
  let(:token) { 'aHfu0XVGX2sjf5vmbEji8A' }

  before { allow(User).to receive(:new_token).and_return(token) }

  describe '/new' do
    context 'With valid email' do
      before do
        visit '/password_resets/new'
        fill_in 'password_reset_email', with: email
        click_on 'Submit'
      end

      it 'send email and redirect to root' do
        expect(current_path).to eq '/'
        expect(page).to have_content 'Email sent with password reset instructions'
      end
    end

    context 'With invalid email' do
      let(:dummy_email) { 'dummy@example.com' }

      before do
        visit '/password_resets/new'
        fill_in 'password_reset_email', with: dummy_email
        click_on 'Submit'
      end

      it 'cannot send email' do
        expect(page).to have_content 'Email address not found'
        expect(current_path).to eq '/password_resets'
      end
    end
  end

  describe '/edit' do
    let(:new_password) { 'password' }

    before do
      visit '/password_resets/new'
      fill_in 'password_reset_email', with: user.email
      click_on 'Submit'
    end

    context 'With valid new password' do
      before do
        # Update password
        visit "/password_resets/#{token}/edit?email=#{CGI::escape(user.email)}"
        fill_in 'user_password',              with: new_password
        fill_in 'user_password_confirmation', with: new_password
        click_on 'Update password'
      end

      it 'succeed to update new password' do
        expect(current_path).to eq "/users/#{user.id}"
        expect(user.password).to eq new_password
      end
    end

    context 'With expired link' do
      before do
        # Update password_reset
        target_user = User.find_by(email: email)
        target_user.update!(reset_sent_at: target_user.reset_sent_at - 3.hours)

        # Vist Update page
        visit "/password_resets/#{token}/edit?email=#{CGI::escape(user.email)}"
      end

      it 'cannot display update form' do
        expect(page).to have_content 'Password reset has expired.'
        expect(current_path).to eq '/password_resets/new'
      end
    end

    context 'With blank password' do
      before do
        # Update password
        visit "/password_resets/#{token}/edit?email=#{CGI::escape(user.email)}"
        fill_in 'user_password',              with: ''
        fill_in 'user_password_confirmation', with: ''
        click_on 'Update password'
      end

      it 'cannot update password' do
        expect(current_path).to eq "/password_resets/#{token}"
        expect(page).to have_content "Password can't be blank"
      end
    end
  end
end

