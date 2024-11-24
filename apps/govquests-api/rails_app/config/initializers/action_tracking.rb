Rails.application.config.after_initialize do
  ActionTracking::Container.tap do |container|
    container.register("services.agora") { AgoraApi::Client.new }
    container.register("services.gitcoin") { GitcoinPassportApi.new }
    container.register("services.ens") { EnsSubgraphClient.new }
    container.register("services.email") { ActionTracking::VerifyEmailClient }
    container.register("services.balance") { ActionTracking::OpTokenBalance }
    ActionTracking::Container.register("services.discourse") { Services::Discourse.new }
  end
end
