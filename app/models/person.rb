class Person < ActiveRecord::Base
  has_many :members
  has_many :groups, through: :members
  has_many :person_availabilities
  has_many :slots, through: :person_availabilities
  has_many :scheduled_spots

  validates :first_name, presence: true
  validates :email,
    presence: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "is invalid"
    }
end
