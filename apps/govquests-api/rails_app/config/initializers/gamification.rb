Rails.application.config.after_initialize do
  Gamification::Container.tap do |container|
    container.register("services.agora") { AgoraApi::Client.new }
  end
end
