require_relative "base"

module ActionTracking
  module Strategies
    class Ens < Base
      include Infra::Import["services.ens"]

      private

      def on_start_execution
        address = start_data[:address]
        domains = ens_domains(address).domains
        start_data.merge({
          domains: domains
        })
      end

      # TODO: reflect about this. This is more of a validation of the requirements of the action
      # rather than about the completion data itself. Completion data is entirely determined by the user,
      # and here what we want is to ensure that the user has the required domains, which have already been
      # fetched in the start_execution method.
      def completion_data_valid?
        start_data.present? && start_data.with_indifferent_access[:domains] && start_data.with_indifferent_access[:domains].any?
      end

      def ens_domains(address)
        @ens_domains ||= ens.domains(address: address.downcase)
      end
    end
  end
end
