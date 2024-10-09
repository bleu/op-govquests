require_relative "../../govquests/configuration"
require_relative "../../infra/lib/infra"

class ReadModelsConfiguration
  def call(event_store, command_bus)
    enable_res_infra_event_linking(event_store)

    enable_read_model(event_store, :authentication)
    enable_read_model(event_store, :quests)
    enable_read_model(event_store, :rewarding)
    enable_read_model(event_store, :action_tracking)
    enable_read_model(event_store, :gamification)
    enable_read_model(event_store, :notifications)

    GovQuests::Configuration.new.call(event_store, command_bus)
  end

  private

  def enable_read_model(event_store, model_name)
    klass = "#{model_name.to_s.camelize}::ReadModelConfiguration".constantize
    klass.new.call(event_store)
  rescue => e
    Rails.logger.error "Failed to enable #{model_name} read model: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def enable_res_infra_event_linking(event_store)
    [
      RailsEventStore::LinkByEventType.new,
      RailsEventStore::LinkByCorrelationId.new,
      RailsEventStore::LinkByCausationId.new
    ].each { |h| event_store.subscribe_to_all_events(h) }
  end
end