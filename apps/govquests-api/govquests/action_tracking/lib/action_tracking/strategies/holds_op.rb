module ActionTracking
  module Strategies
    class HoldsOp < Base
      include Import['services.balance']

      def on_start_execution
        {
          balance: op_balance
        }
      end

      def start_data_valid? 
        start_data[:address].present? && has_op_tokens?
      end

      def can_complete?
        start_data_valid?
      end

      private

      def has_op_tokens?
        (op_balance || 0) > 0
      end   

      def op_balance
        @op_balance ||= balance.get_balance(start_data[:address])
      end
    end
  end
end