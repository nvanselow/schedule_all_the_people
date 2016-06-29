class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :blocks, dependent: :destroy
  has_many :members, through: :group
  has_many :people, through: :members

  validates :name, presence: true
  validates :user, presence: true
  validates :group, presence: true
  validates :slot_duration,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  def self.all_for_user(user)
    Event.where(user: user)
  end

  def self.find_for_user(id, user)
    Event.where(id: id, user: user).first
  end

  def slots
    slots = []
    blocks.each do |block|
      slots.concat(block.slots)
    end
    slots
  end

  def schedule!
    scheduler = Scheduler.new(people, slots)

    if(scheduler.run)
      true
    else
      scheduler
    end
  end

end
