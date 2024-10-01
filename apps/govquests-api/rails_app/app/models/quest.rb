class Quest < ApplicationRecord
  validates :img_url, presence: true
  validates :title, presence: true
  validates :reward_type, presence: true
  validates :intro, presence: true

  serialize :steps, Array
end