require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:default_url)  { Rails.configuration.action_mailer.default_url_options }
  let(:url)  { "#{default_url[:protocol]}://#{default_url[:host]}" }

  describe "account_activation" do
    let(:user) { FactoryBot.create(:user, activated: false, activated_at: nil, activation_digest: nil) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.name)
    end
  end

  describe "password_reset" do
    let(:user) { FactoryBot.create(:user, reset_digest: User.new_token, reset_sent_at: Time.now) }
    let(:mail) { UserMailer.password_reset(user) }

    before { user.create_reset_digest }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('reset your password click the link below:')
    end
  end
end
