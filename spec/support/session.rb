RSpec.shared_context :login_as_non_admin_user do |email, password, remember_option|
  let!(:user) { User.find_by(email: email) || FactoryBot.create(:user, admin: false, email: email, password: password) }

  before do
    visit '/login'
    fill_in 'session_email', with: email
    fill_in 'session_password', with: password
    check 'session_remember_me' if remember_option
    within('.login_form') { click_on 'Log in' }
  end
end

RSpec.shared_context :login_as_admin_user do |email, password, remember_option|
  let!(:user) { User.find_by(email: email) || FactoryBot.create(:user, admin: true, email: email, password: password) }

  before do
    fill_in 'session_email', with: email
    fill_in 'session_password', with: password
    check 'session_remember_me' if remember_option
    within('.login_form') { click_on 'Log in' }
  end
end

