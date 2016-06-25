class Member < ActiveRecord::Base
  belongs_to :group
  belongs_to :person

  validates :group, presence: true
  validates :person, presence: true
end
