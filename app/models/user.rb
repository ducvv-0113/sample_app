class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email_regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token

  validates :name, presence: true,
    length: {maximum: Settings.validations.user.name_max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validations.user.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validations.user.pass_min_length},
    allow_nil: true

  before_create :create_activation_digest
  before_save :downcase_email

  has_secure_password

  scope :is_activated, ->{where activated: true}

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
