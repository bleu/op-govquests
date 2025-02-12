module ActionTracking
  module Strategies
    # Implement a mix of the Strategy and Template Method patterns
    class Base
      class CompletionDataVerificationFailed < StandardError; end

      class StartDataVerificationFailed < StandardError; end

      attr_reader :start_data, :completion_data

      def initialize(start_data: nil, completion_data: nil)
        @start_data = start_data&.with_indifferent_access
        @completion_data = completion_data&.with_indifferent_access
      end

      def start_execution
        raise StartDataVerificationFailed unless start_data_valid?

        on_start_execution.merge({action_type:})
      end

      def complete_execution(dry_run: false)
        return completion_data_valid? && can_complete? if dry_run

        raise CompletionDataVerificationFailed.new("Completion data is invalid") unless completion_data_valid?

        on_complete_execution.merge({action_type:})
      end

      private

      def action_type
        self.class.name.demodulize.underscore
      end

      def on_start_execution
        start_data
      end

      def on_complete_execution
        completion_data
      end

      def start_data_valid?
        true
      end

      def can_complete?
        true
      end

      def completion_data_valid?
        true
      end
    end
  end
end
