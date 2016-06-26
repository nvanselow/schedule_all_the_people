class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :blocks, dependent: :destroy
  has_many :members, through: :group
  has_many :people, through: :members

  validates :name, presence: true
  validates :user, presence: true
  validates :group, presence: true

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
