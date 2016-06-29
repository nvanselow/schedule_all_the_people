class Group < ActiveRecord::Base
  belongs_to :user
  has_many :members
  has_many :people, through: :members

  validates :name, presence: true
  validates :last_used, timeliness: :on, allow_blank: true, allow_nil: true

  def self.all_for_user(user)
    Group.where(user: user)
  end

  def self.find_for_user(id, user)
    Group.where(id: id, user: user).first
  end
end
