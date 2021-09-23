class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  MAX_LENGTH_OF_NAME = 50.freeze
  MAX_LENGTH_OF_EMAIL = 255.freeze
  MAX_LENGTH_OF_PASSWORD = 8.freeze

  before_save   :downcase_email
  before_create :create_activation_digest


  validates :name,     presence: true,
                       length: { maximum: MAX_LENGTH_OF_NAME }
  validates :email,    length: { maximum: MAX_LENGTH_OF_EMAIL },
                       format: { with: URI::MailTo::EMAIL_REGEXP },
                       uniqueness: true
  validates :password, presence: true,
                       length: { minimum: MAX_LENGTH_OF_PASSWORD },
                       allow_nil: true

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

  # End of private
end

