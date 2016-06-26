class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :people, through: :groups, dependent: :destroy
  has_many :tokens, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :first_name, presence: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "is invalid"
    }

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.provider = provider
      user.uid = uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar_url = auth.info.image
    end
  end

  def get_token(provider)
    tokens.where(provider: provider).first
  end
end
