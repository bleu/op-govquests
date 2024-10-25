require_relative "base"

module ActionTracking
  module Strategies
    class WalletVerification < Base
      def start_data_valid?
        return start_data[:address].present?
        # TODO 
        # Check if address is a valid Ethereum address
      end

      def can_complete?
        start_data_valid?
      end
    end
  end
end
