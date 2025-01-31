module Processes
  class CreateGameProfileOnUserRegistered
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Authentication::UserRegistered])
    end

    def call(event)
      user_id = event.data[:user_id]

      return if ::Gamification::GameProfileReadModel.exists?(profile_id: user_id)

      
      command = ::Gamification::CreateGameProfile.new(
        profile_id: user_id,
      )

      @command_bus.call(command)
    end
  end
end