require_relative "base"

module ActionTracking
  module Strategies
    class Ens < Base
      private

      def on_start_execution
        address = start_data[:address]
        domains = EnsSubgraphClient.new.domains(owner: address).domains

        start_data.extend({
          domains: domains
        })
      end

      # TODO: reflect about this. This is more of a validation of the requirements of the action
      # rather than about the completion data itself. Completion data is entirely determined by the user,
      # and here what we want is to ensure that the user has the required domains, which have already been
      # fetched in the start_execution method.
      def completion_data_valid?
        completion_data[:domains].any?
      end
    end
  end
end
