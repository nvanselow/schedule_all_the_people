class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :people, through: :groups, dependent: :destroy

  validates :uuid, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "is invalid"
    }
end
