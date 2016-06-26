class Group < ActiveRecord::Base
  belongs_to :user
  has_many :members
  has_many :people, through: :members

  validates :name, presence: true
  validates :last_used, timeliness: :on, allow_blank: true, allow_nil: true
end
