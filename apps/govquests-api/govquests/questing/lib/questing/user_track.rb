module Questing
  class UserTrack
    include AggregateRoot

    TrackNotStartedError = Class.new(StandardError)
    TrackAlreadyStartedError = Class.new(StandardError)
    TrackAlreadyCompletedError = Class.new(StandardError)
    QuestsNotCompletedError = Class.new(StandardError)
    InvalidQuestError = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :not_started
      @track_id = nil
      @user_id = nil
      @quests = []
      @progress = {}
    end

    def start(track_id, user_id, quests)
      raise TrackAlreadyStartedError if @state == :in_progress
      raise TrackAlreadyCompletedError if @state == :completed

      apply TrackStarted.new(data: {
        user_track_id: @id,
        track_id: track_id,
        user_id: user_id,
        quests: quests
      })
    end

    def add_progress(quest_id)
      raise TrackNotStartedError unless @state == :in_progress

      unless @quests.include?(quest_id)
        raise InvalidQuestError, "Quest #{quest_id} is not part of this track."
      end

      apply TrackProgressUpdated.new(data: {
        user_track_id: @id,
        quest_id: quest_id,
      })

      complete if all_quests_completed?
    end

    def complete
      raise TrackNotStartedError unless @state == :in_progress
      raise TrackAlreadyCompletedError if @state == :completed
      raise QuestsNotCompletedError unless all_quests_completed?

      apply TrackCompleted.new(data: {
        user_track_id: @id,
        track_id: @track_id,
        user_id: @user_id
      })
    end

    private

    def all_quests_completed?
      (@quests - @progress.keys).empty?
    end

    on TrackStarted do |event|
      @state = :in_progress
      @track_id = event.data[:track_id]
      @user_id = event.data[:user_id]
      @quests = event.data[:quests]
      @progress = {}
    end

    on TrackProgressUpdated do |event|
      @progress[event.data[:quest_id]] = true
    end

    on TrackCompleted do |event|
      @state = :completed
    end
  end
end
