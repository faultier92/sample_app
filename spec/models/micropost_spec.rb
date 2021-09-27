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
end

