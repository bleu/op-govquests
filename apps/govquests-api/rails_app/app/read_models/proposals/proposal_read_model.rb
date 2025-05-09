module Proposals
  class ProposalReadModel < ApplicationRecord
    self.table_name = "proposals"

    validates :proposal_id, presence: true
    validates :title, presence: true
    validates :description, presence: true
    validates :status, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    scope :active, -> { where("start_date <= ? AND end_date >= ?", Time.current, Time.current) }
    scope :close_to_end, -> { where("end_date <= ?", Time.current + 2.days) }
  end
end

# == Schema Information
#
# Table name: proposals
#
#  id          :bigint           not null, primary key
#  description :string
#  end_date    :datetime
#  start_date  :datetime
#  status      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  proposal_id :string           not null
#
# Indexes
#
#  index_proposals_on_proposal_id  (proposal_id) UNIQUE
#
