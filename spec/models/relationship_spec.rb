require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }
  let(:relationship) { FactoryBot.build(:relationship, follower: follower, followed: followed) }

  describe '#valid?' do
    subject { relationship.valid? }

    context 'invalid relarionship' do
      context 'without follower' do
        let(:follower) { nil }

        it { is_expected.to eq false }
      end

      context 'without follewed' do
        let(:followed) { nil }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#follow' do
    let(:user) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }

    subject { user.following?(another_user) }

    context 'user does not follow another_user' do
      it { is_expected.to eq false }
    end

   context 'user follows another_user' do
      before { user.follow(another_user) }
      it { is_expected.to eq true }
    end
  end

  describe '#unfollow' do
    let(:user) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }

    before { user.follow(another_user) }

    subject { user.following?(another_user) }

    context 'user does not unfollow another_user' do
      it { is_expected.to eq true }
    end

   context 'user unfollows another_user' do
      before { user.unfollow(another_user) }
      it { is_expected.to eq false }
    end
  end
end

