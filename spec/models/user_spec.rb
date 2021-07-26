require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    let(:user) { FactoryBot.build(:user, name: name, email: email, password: password, password_confirmation: password) }
    let(:name) { 'sample' }
    let(:email) { 'sample@example.com' }
    let(:password) { 'password' }

    subject { user.valid? }

    context 'invalid users with' do
      context 'empty email' do
        let(:name) { '     ' }
        it { is_expected.to eq false }
      end

      context 'nil as name' do
        let(:name) { nil }
        it { is_expected.to eq false }
      end

      context 'too long name' do
        let(:name) { 'a' * (User::MAX_LENGTH_OF_NAME + 1) }
        it { is_expected.to eq false }
      end

      context 'too long email' do
        let(:email) { 'a' * (User::MAX_LENGTH_OF_EMAIL - '@example.com'.length + 1) + '@example.com' }
        it { is_expected.to eq false }
      end

      context 'invalid format of email' do
        let(:email) { 'invalid.example.com' }
        it { is_expected.to eq false }
      end

      context 'duplicated email' do
        let(:email) { 'dup@example.com' }
        before { FactoryBot.create(:user, name: name,
                                          email: email.capitalize,
                                          password: password,
                                          password_confirmation: password)
               }

        it { is_expected.to eq false }
      end

      context 'too short password' do
        let(:password) { 'a' * (User::MAX_LENGTH_OF_PASSWORD - 1) }
        it { is_expected.to eq false }
      end
    end

    context 'valid users with' do
      context 'capitalized email' do
        let(:email) { 'caP@eXamPle.com' }
        before { user.save! }
        it { expect(user.email).to eq email.downcase! }
      end
    end
  end
end
