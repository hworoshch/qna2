class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, through: :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: [:github, :vkontakte]

  def owner?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def create_unconfirmed_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid, confirmation_token: Devise.friendly_token)
  end

  def generate_password
    new_password = Devise.friendly_token[0, 20]
    self.password = self.password_confirmation = new_password
    self
  end

  def auth_confirmed?(auth)
    auth && authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirmed?
  end
end
