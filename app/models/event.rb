class Event < ActiveRecord::Base
  belongs_to :user
  has_many :blocks, dependent: :destroy

  validates :name, presence: true
end
