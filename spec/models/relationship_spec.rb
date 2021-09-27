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
end

