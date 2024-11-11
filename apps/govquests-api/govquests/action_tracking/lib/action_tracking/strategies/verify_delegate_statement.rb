require_relative "base"

module ActionTracking
  module Strategies
    class VerifyDelegateStatement < Base
      def on_start_execution
        {
          statement: agora_delegate["statement"]
        }
      end

      def start_data_valid?
        start_data[:address].present? && verify_statement_signature
      end

      def can_complete?
        start_data_valid?
      end

      private

      def verify_statement_signature
        # TODO: asked Agora team for how to verify this because it's not clear how they prepare the payload for signing
        # and we need it to verify the statement_signature

        agora_delegate["statement"]["signature"].present?
        # PROTOTYPE:
        # signature = agora_delegate["statement"]["signature"]
        # message_to_sign = JSON.generate(agora_delegate["statement"]["payload"])
        # # recovered_key = Eth::Signature.personal_recover message_to_sign, signature
        # # address = Eth::Util.public_key_to_address(recovered_key).to_s
        # Eth::Signature.verify message_to_sign, signature, start_data["address"]
      end

      def agora_delegate
        @agora_delegate ||= AgoraApi::Client.new.get_delegate(start_data[:address])
      end
    end
  end
end
