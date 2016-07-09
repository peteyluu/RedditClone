# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  attr_reader :password
  validates :email, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  # Since you add a validation to password, make sure to add reader #password,
  # the validation will call this to check the attribute.
  # Adding the `allow_nil: true`, if the password attribute is left blank, the
  # validation will not run!
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, uniqueness: true
  after_initialize :ensure_session_token

  has_many(
    :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    primary_key: :id
  )
  has_many :posts

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest.to_s).is_password?(password)
  end
end
