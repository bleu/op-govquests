require "pycall/import"

module Safe
  class EthereumClient
    EthereumClient = PyCall.import_module("safe_eth.eth").EthereumClient
    EthereumNetwork = PyCall.import_module("safe_eth.eth").EthereumNetwork

    attr_reader :ethereum_client, :network

    def initialize(rpc_url:, network:)
      @rpc_url = rpc_url
      @network = network

      validate_network!

      @ethereum_client = EthereumClient.call(@rpc_url)
    rescue PyCall::PyError => e
      Rails.logger.error "EthereumClientService Initialization Error: #{e.message}"
      raise "Failed to initialize EthereumClientService: #{e.message}"
    end

    private

    def validate_network!
      networks = {
        "sepolia" => EthereumNetwork.SEPOLIA,
        "optimism" => EthereumNetwork.OPTIMISM
      }

      @network = networks[@network.downcase] || EthereumNetwork.SEPOLIA
    end
  end
end
