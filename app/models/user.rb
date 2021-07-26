class User < ApplicationRecord
  MAX_LENGTH_OF_NAME = 50.freeze
  MAX_LENGTH_OF_EMAIL = 255.freeze
  MAX_LENGTH_OF_PASSWORD = 8.freeze

  before_save { self.email = email.downcase! }

  validates :name,     presence: true,
                       length: { maximum: MAX_LENGTH_OF_NAME }
  validates :email,    length: { maximum: MAX_LENGTH_OF_EMAIL },
                       format: { with: URI::MailTo::EMAIL_REGEXP },
                       uniqueness: true
  validates :password, presence: true,
                       length: { minimum: MAX_LENGTH_OF_PASSWORD }

  has_secure_password
end
