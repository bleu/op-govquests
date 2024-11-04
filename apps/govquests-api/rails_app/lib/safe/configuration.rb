module Safe
  class Configuration
    class << self
      attr_accessor :rpc_url, :safe_address, :system_private_key, :network

      def load!
        if defined?(Rails) && Rails.respond_to?(:application) && Rails.application.respond_to?(:credentials)
          self.rpc_url = Rails.application.credentials.dig(:safe_integration, :rpc_url) || ENV["SAFE_INTEGRATION_RPC_URL"]
          self.safe_address = Rails.application.credentials.dig(:safe_integration, :safe_address) || ENV["SAFE_INTEGRATION_SAFE_ADDRESS"]
          self.system_private_key = Rails.application.credentials.dig(:safe_integration, :system_private_key) || ENV["SAFE_INTEGRATION_SYSTEM_PRIVATE_KEY"]
          self.network = Rails.application.credentials.dig(:safe_integration, :network) || ENV["SAFE_INTEGRATION_NETWORK"] || "SEPOLIA"
        else
          self.rpc_url = ENV["SAFE_INTEGRATION_RPC_URL"]
          self.safe_address = ENV["SAFE_INTEGRATION_SAFE_ADDRESS"]
          self.system_private_key = ENV["SAFE_INTEGRATION_SYSTEM_PRIVATE_KEY"]
          self.network = ENV["SAFE_INTEGRATION_NETWORK"] || "SEPOLIA"
        end

        validate!
      end

      private

      def validate!
        missing = []
        missing << "rpc_url" unless rpc_url
        missing << "safe_address" unless safe_address
        missing << "system_private_key" unless system_private_key
        missing << "network" unless network

        unless missing.empty?
          raise ArgumentError, "Missing Safe::Configuration parameters: #{missing.join(", ")}"
        end
      end
    end
  end
end
