module ActionTracking
  module Strategies
    class HoldsOp < Base
      include Import['services.balance']

      def on_start_execution
        start_data.merge({
          balance: balance.get_balance(start_data[:address])
        })
      end

      def start_data_valid? 
        start_data[:address].present?
      end

      def can_complete?
        start_data_valid?
      end

      private

      def has_op_tokens?
        (start_data["balance"] || 0) > 0
      end   
    end
  end
end