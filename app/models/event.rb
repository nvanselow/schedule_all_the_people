class Event < ActiveRecord::Base
  belongs_to :user
  has_many :blocks, dependent: :destroy

  validates :name, presence: true

  def slots
    slots = []
    blocks.each do |block|
      slots.concat(block.slots)
    end
    slots
  end
end
