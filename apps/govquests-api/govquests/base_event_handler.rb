# govquests/lib/base_event_handler.rb

module GovQuests
  class BaseEventHandler
    def initialize(event_store, resource_class = nil, id_field = :id)
      @event_store = event_store
      @resource_class = resource_class
      @id_field = id_field
    end

    def call(event)
      # This should be overridden by subclasses to handle specific events
      raise NotImplementedError, "Subclasses must implement the `call` method"
    end

    protected

    def find_resource(event, resource_class = @resource_class, id_field = @id_field)
      resource_id = event.data.fetch(id_field)
      resource_class.find_or_initialize_by(id_field => resource_id)
    end

    def update_resource(event, resource_class = @resource_class, id_field = @id_field)
      resource = find_resource(event, resource_class, id_field)
      yield(resource) if block_given?
      resource.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to update resource: #{e.message}"
    end

    def concurrent_safely(event)
      resource_class = @resource_class.name
      resource_id = event.data.fetch(@id_field)

      ApplicationRecord.with_advisory_lock(resource_class, resource_id) do
        yield
      end
    rescue ActiveRecord::StatementInvalid => e
      Rails.logger.error "Concurrency issue with event #{event.event_type}: #{e.message}"
    end

    private

    attr_reader :event_store, :resource_class, :id_field
  end
end
