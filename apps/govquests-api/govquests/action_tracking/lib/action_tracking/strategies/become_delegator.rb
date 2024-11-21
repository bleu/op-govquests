module ActionTracking
  module Strategies
    class BecomeDelegator < Base
      def on_start_execution
        
      end
      
      def start_data_valid?
        start_data[:address].present?
      end
    end
  end
end