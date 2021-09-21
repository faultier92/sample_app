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
        expect(current_path).to eq "/"
        expect(page).to have_content 'Please check your email to activate your account.'
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

  describe '/edit' do
    let(:name)                  { 'sample_user' }
    let(:email)                 { 'sample@example.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }
    let!(:user) { FactoryBot.create(:user, email: 'original@example.com', password: 'original_password') }

    include_context :login_as_non_admin_user, 'original@example.com', 'original_password', false

    subject do
      visit "/users/#{user.id}/edit"
      fill_in 'user_name',                  with: name
      fill_in 'user_email',                 with: email
      fill_in 'user_password',              with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_on 'Save changes'
    end

    context 'With appropriate values' do
      it 'succeed to update account' do
        expect { subject }.to change { User.count }.by(0)
        expect(current_path).to eq "/users/#{User.last.id}"
        expect(page).to have_content 'Profile updated'
      end
    end

    context 'With inappropriate name' do
      context 'when name is blank' do
        let(:name) { '' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Name can't be blank"
          expect(current_path).to eq "/users/#{user.id}"
        end
      end
    end

    context 'With inappropriate email' do
      context 'when email is blank' do
        let(:email) { '' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Email is invalid"
          expect(current_path).to eq "/users/#{user.id}"
        end
      end

      context 'when email is duplicated' do
        let!(:dup_user) { FactoryBot.create(:user, email: email, password: password) }

        before do
          visit "/users/#{user.id}/edit"
          fill_in 'user_email', with: email
          click_on 'Save changes'
        end

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq "/users/#{user.id}"
        end
      end

      context 'when email is invalid format' do
        let(:email) { 'invalid_format_email' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content 'Email is invalid'
          expect(current_path).to eq "/users/#{user.id}"
        end
      end
    end

    context 'With appropriate password' do
      context 'when password is blank' do
        let(:password) { '' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(current_path).to eq "/users/#{User.last.id}"
          expect(page).to have_content 'Profile updated'
        end
      end
    end

    context 'With inappropriate password' do
      context 'when password is less than 8 charactors' do
        let(:password) { 'sevench' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Password is too short (minimum is 8 characters)"
          expect(current_path).to eq "/users/#{user.id}"
        end
      end

      context 'when password confirmation is blank' do
        let(:password_confirmation) { '' }

        it 'failed to update account' do
          expect { subject }.to change { User.count }.by(0)
          expect(page).to have_content "Password confirmation doesn't match Password"
          expect(current_path).to eq "/users/#{user.id}"
        end
      end
    end

    context 'Visit edit page without logged in' do
      before do
        click_on 'Log out'
        visit "/users/#{user.id}/edit"
      end

      it 'redirect to login page' do
        expect(page).to have_content('Please log in.')
        expect(current_path).to eq '/login'
      end
    end

    context 'Login after redirect to login page' do
      before do
        click_on 'Log out'
        visit "/users/#{user.id}/edit"
        # redirect to login page
        fill_in 'session_email',    with: 'original@example.com' 
        fill_in 'session_password', with: 'original_password'
        within('.login_form') { click_on 'Log in' }
      end

      it 'fowards edit page' do
        expect(current_path).to eq "/users/#{user.id}/edit"
      end
    end

    context 'Visit edit page with incorrent user' do
      let!(:edit_user) { FactoryBot.create(:user) }

      before { visit "/users/#{edit_user.id}/edit" }

      it 'redirect to root page' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe '/users' do
    let!(:users) { FactoryBot.create_list(:user, 30) }

    context 'With non admin user' do
      include_context :login_as_non_admin_user, 'non_admin_user@example.com', 'password', false
 
      before { visit '/users' }

      context 'Visit users index with more than 30 users' do
        it 'has pagination link' do
          expect(page).to have_css 'div.pagination'
        end

        it 'not display delete button' do
          expect(page).not_to have_content 'delete'
        end

        it 'displays only 30 users' do
          User.first(30).each do |user|
            expect(page).to have_content(user.name)
          end
          expect(page).not_to have_content(User.last.name)
        end
      end
    end

    context 'With admin user' do
      include_context :login_as_admin_user, 'admin_user@example.com', 'password', false

      before { visit '/users' }

      context 'display link and button' do
        it 'has pagination link' do
          expect(page).to have_css 'div.pagination'
        end

        it 'display delete button' do
          expect(page).to have_content 'delete'
        end
      end

      context 'click delete button' do
        subject { click_on 'delete', match: :first } 

        it 'delete a user' do
          expect { subject }.to change { User.count }.by(-1)
        end
      end
    end
  end

  describe '/users/:id' do
    context 'Visit edit page with activated false' do
      let(:not_activated_user) { FactoryBot.create(:user, activated: false) }

      before { visit "/users/#{not_activated_user.id}" }

      it 'redirect to root page' do
        expect(page).to have_content('The user is not activated.')
        expect(current_path).to eq '/'
      end
    end
  end
end

