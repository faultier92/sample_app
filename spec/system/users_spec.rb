require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '/signup' do
    let(:name)                  { 'sample_user' }
    let(:email)                 { 'sample@example.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }

    subject do
      visit '/signup'
      fill_in 'user_name',                  with: name
      fill_in 'user_email',                 with: email
      fill_in 'user_password',              with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_on 'Create account'
    end

    context 'With appropriate values' do
      it 'succeed to create new account' do
        expect { subject }.to change { User.count }.by(1)
        expect(current_path).to eq "/users/#{User.last.id}"
        expect(page).to have_content 'Welcome to the Sample App!'
      end
    end

    context 'With inappropriate name' do
      context 'when name is blank' do
        let(:name) { '' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Name can't be blank"
          expect(current_path).to eq '/users'
        end
      end
    end

    context 'With inappropriate email' do
      context 'when email is blank' do
        let(:email) { '' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Email is invalid"
          expect(current_path).to eq '/users'
        end
      end

      context 'when email is duplicated' do
        before { FactoryBot.create(:user, email: email) }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq '/users'
        end
      end

      context 'when email is invalid format' do
        let(:email) { 'invalid_format_email' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content 'Email is invalid'
          expect(current_path).to eq '/users'
        end
      end
    end

    context 'With inappropriate password' do
      context 'when password is blank' do
        let(:password) { '' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Password can't be blank"
          expect(current_path).to eq '/users'
        end
      end

      context 'when password is less than 8 charactors' do
        let(:password) { 'sevench' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Password is too short (minimum is 8 characters)"
          expect(current_path).to eq '/users'
        end
      end

      context 'when password confirmation is blank' do
        let(:password_confirmation) { '' }

        it 'failed to create new account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Password confirmation doesn't match Password"
          expect(current_path).to eq '/users'
        end
      end
    end
  end
end

