require "infra"
require_relative "proposals/commands"
require_relative "proposals/events"

require_relative "proposals/proposal"

module Proposals
  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Proposals::CreateProposal", aggregate: Proposal do |proposal, cmd|
      proposal.create(cmd.title, cmd.description, cmd.status, cmd.start_date, cmd.end_date)
    end
  end
end
