class Quest < ApplicationRecord
  validates :img_url, presence: true
  validates :title, presence: true
  serialize :rewards, Array, presence: true
  validates :intro, presence: true
  validates :status, presence: true


  serialize :steps, Array, presence: true
end