require 'rails_helper'

RSpec.describe 'Micropost', type: :system do
  let(:content) { 'sample_content' }

  include_context :login_as_non_admin_user, 'sample@example.com', 'password', false

  describe '/' do
    context 'create' do
      before do
        visit '/'
        fill_in :micropost_content, with: content
        # TODO upload image
        click_on 'Post'
      end

      context 'with invalid values' do
        context 'empty content' do
          let(:content) { '' }

          it 'failed to save micropost' do
            expect(current_path).to eq '/microposts'
            expect(page).to have_content "Content can't be blank"
          end
        end

        context 'too long content' do
          let(:content) { 'a' * 141 }

          it 'failed to save micropost' do
            expect(current_path).to eq '/microposts'
            expect(page).to have_content "Content is too long (maximum is 140 characters)"
          end
        end

        # TODO
        # context 'too big image size' do
        # end
      end

      context 'with valid values' do
        context 'valid content' do
          let(:content) { 'a' * 140 }
        
          it 'failed to save micropost' do
            expect(current_path).to eq '/'
            # expect(page).to have_content content
            max_length = 30
            expected_content = content.length.to_i <= max_length ? content : "#{content[0...(max_length - 3)]}..."
            expect(page).to have_content expected_content
            expect(page).to have_content 'Micropost created!'
          end
        end

        # TODO
        # context 'resize large image' do
        # end
      end
    end

    context 'index' do
      context 'for current_user' do
        let!(:micropost) { FactoryBot.create(:micropost, user: user, content: content) }

        before { visit '/' }

        it 'display microposts' do
          expect(page).to have_content content
        end
      end

      context 'for another user' do
        let!(:another_user)   { FactoryBot.create(:user) }
        let!(:micropost) { FactoryBot.create(:micropost, user: another_user, content: content) }

        before { visit "/users/#{another_user.id}" }

        it 'display microposts' do
          expect(page).to have_content content
        end
      end 
    end
  end
end

