class User < ApplicationRecord
  attr_accessor :remember_token

  MAX_LENGTH_OF_NAME = 50.freeze
  MAX_LENGTH_OF_EMAIL = 255.freeze
  MAX_LENGTH_OF_PASSWORD = 8.freeze

  before_save { self.email = email.downcase }

  validates :name,     presence: true,
                       length: { maximum: MAX_LENGTH_OF_NAME }
  validates :email,    length: { maximum: MAX_LENGTH_OF_EMAIL },
                       format: { with: URI::MailTo::EMAIL_REGEXP },
                       uniqueness: true
  validates :password, presence: true,
                       length: { minimum: MAX_LENGTH_OF_PASSWORD }

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

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end

