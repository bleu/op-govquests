require_relative "base"

module ActionTracking
  module Strategies
    class WalletVerification < Base
      def start_data_valid?
        # TODO: OP-472, check if address is a valid Ethereum address
        return start_data[:address].present?
      end

      def can_complete?
        start_data_valid?
      end
    end
  end
end
