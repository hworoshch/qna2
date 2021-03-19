class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, through: :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: [:github]

  def owner?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end
end
