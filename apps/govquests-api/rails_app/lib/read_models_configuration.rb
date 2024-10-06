require_relative "../../govquests/configuration"
require_relative "../../infra/lib/infra"

class ReadModelsConfiguration
  def call(event_store, command_bus)
    enable_res_infra_event_linking(event_store)

    enable_authentication_read_model(event_store)
    enable_quests_read_model(event_store)
    enable_rewarding_read_model(event_store)
    enable_action_tracking_read_model(event_store)
    enable_gamification_read_model(event_store)
    enable_notifications_read_model(event_store)

    GovQuests::Configuration.new.call(event_store, command_bus)
  end

  private

  def enable_authentication_read_model(event_store)
    Authentication::ReadModelConfiguration.new.call(event_store)
  end

  def enable_quests_read_model(event_store)
    Questing::ReadModelConfiguration.new.call(event_store)
  end

  def enable_rewarding_read_model(event_store)
    Rewarding::ReadModelConfiguration.new.call(event_store)
  end

  def enable_action_tracking_read_model(event_store)
    ActionTracking::ReadModelConfiguration.new.call(event_store)
  end

  def enable_gamification_read_model(event_store)
    Gamification::ReadModelConfiguration.new.call(event_store)
  end

  def enable_notifications_read_model(event_store)
    Notifications::ReadModelConfiguration.new.call(event_store)
  end

  def enable_res_infra_event_linking(event_store)
    [
      RailsEventStore::LinkByEventType.new,
      RailsEventStore::LinkByCorrelationId.new,
      RailsEventStore::LinkByCausationId.new
    ].each { |h| event_store.subscribe_to_all_events(h) }
  end
end
