Rails.application.config.after_initialize do
  Infra::Container.tap do |container|
    container.register("services.agora") { AgoraApi::Client.new }
    container.register("services.gitcoin") { GitcoinPassportApi.new }
    container.register("services.ens") { EnsSubgraphClient.new }
    container.register("services.email") { ActionTracking::VerifyEmailClient }
    container.register("services.balance") { ActionTracking::OpTokenBalance }
    container.register("services.discourse") { DiscourseApiClient.new }
    container.register("services.curia_hub") { CuriaHubApi::Client.new }
  end
end
