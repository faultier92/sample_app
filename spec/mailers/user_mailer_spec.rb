require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user, activated: false, activated_at: nil, activation_digest: nil) }
    let(:mail) { UserMailer.account_activation(user) }
    let(:default_url)  { Rails.configuration.action_mailer.default_url_options }
    let(:url)  { "#{default_url[:protocol]}://#{default_url[:host]}" }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.name)
      # expect(mail.body.encoded).to match("#{url}/account_activations/#{user.activation_token}/edit?email=#{CGI::escape(user.email)}")
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
