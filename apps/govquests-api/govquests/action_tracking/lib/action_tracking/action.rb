module ActionTracking
  class Action
    include AggregateRoot

    class AlreadyCreatedError < StandardError; end

    def initialize(id)
      @id = id
      @state = "draft"
      @action_data = {}
      @action_type = nil
      @display_data = {}
    end

    def create(action_type, action_data, display_data)
      raise AlreadyCreatedError if @state != "draft"

      apply ActionCreated.new(data: {
        action_id: @id,
        action_type: action_type,
        action_data: action_data,
        display_data: display_data
      })
    end

    def update(action_data, display_data)
      apply ActionUpdated.new(data: {
        action_id: @id,
        action_data: action_data,
        display_data: display_data
      })
    end

    attr_reader :action_type

    private

    on ActionCreated do |event|
      @state = "created"
      @action_data = event.data[:action_data]
      @action_type = event.data[:action_type]
      @display_data = event.data[:display_data]
    end

    on ActionUpdated do |event|
      @action_data = event.data[:action_data]
      @display_data = event.data[:display_data]
    end
  end
end
