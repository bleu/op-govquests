require_relative "../../govquests/configuration"
require_relative "../../infra/lib/infra"

class ReadModelsConfiguration
  def call(event_store, command_bus)
    enable_res_infra_event_linking(event_store)

    enable_authentication_read_model(event_store)
    enable_quests_read_model(event_store)

    Govquests::Configuration.new.call(event_store, command_bus)
  end

  private

  def enable_authentication_read_model(event_store)
    Authentication::ReadModelConfiguration.new.call(event_store)
  end

  def enable_quests_read_model(event_store)
    Questing::ReadModelConfiguration.new.call(event_store)
  end

  def enable_res_infra_event_linking(event_store)
    [
      RailsEventStore::LinkByEventType.new,
      RailsEventStore::LinkByCorrelationId.new,
      RailsEventStore::LinkByCausationId.new
    ].each { |h| event_store.subscribe_to_all_events(h) }
  end
end
