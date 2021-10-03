require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:content) { 'content' }
  let(:micropost) { FactoryBot.build(:micropost, user: user, content: content) }

  subject { micropost.valid? }

  describe '#valid?' do
    context 'invalid micropost with' do
      context 'too long content' do
        let(:content) { 'a' * 141 }
        it { is_expected.to eq false }
      end

      context 'empty user' do
        let(:user) { nil }
        it { is_expected.to eq false }
      end
    end

    context 'valid micropost' do
      it { is_expected.to eq true }
    end
  end

  describe '#feed' do
    let(:followed_user) { FactoryBot.create(:user) }
    let(:unfollowed_user) { FactoryBot.create(:user) }
    let!(:following) { FactoryBot.create(:relationship, followed: followed_user, follower: user) }
    let!(:user_micropost) { FactoryBot.create(:micropost, user: user) }
    let!(:followed_user_micropost) { FactoryBot.create(:micropost, user: followed_user) }
    let!(:unfollowed_user_micropost) { FactoryBot.create(:micropost, user: unfollowed_user) }

    context 'when user follows followed_user' do
      it 'includes its own micropost' do
        expect(user.feed).to include user_micropost
      end

      it 'includes micropost of following user' do
        expect(user.feed).to include followed_user_micropost
      end

      it 'not includes micropost of non following user' do
        expect(user.feed).not_to include unfollowed_user_micropost
      end
    end
  end
end

