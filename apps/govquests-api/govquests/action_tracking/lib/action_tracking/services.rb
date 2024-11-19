module ActionTracking
  module Services
    module AgoraService
      def get_delegate(address)
        raise NotImplementedError
      end
    end

    module GitcoinService
      def get_signing_message
        raise NotImplementedError
      end

      def submit_passport(address, signature, nonce)
        raise NotImplementedError
      end
    end

    module EnsService
      def domains(address:)
        raise NotImplementedError
      end
    end

    module EmailService
      def send_email_async(email, token)
        raise NotImplementedError
      end
    end
  end
end
