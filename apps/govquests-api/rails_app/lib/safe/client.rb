require "pycall/import"

module Safe
  class Client
    Safe = PyCall.import_module("safe_eth.safe").Safe
    TransactionServiceApi = PyCall.import_module("safe_eth.safe.api.transaction_service_api").TransactionServiceApi
    HexBytes = PyCall.import_module("hexbytes").HexBytes
    Web3 = PyCall.import_module("web3").Web3

    def initialize(safe_address:, ethereum_client:, network:)
      @safe_address = safe_address
      @ethereum_client = ethereum_client
      @network = network

      validate_safe_address!

      @safe = Safe.call(@safe_address, @ethereum_client)
      @transaction_service_api = TransactionServiceApi.call(
        network: @network,
        ethereum_client: @ethereum_client
      )
    rescue PyCall::PyError => e
      Rails.logger.error "SafeService Initialization Error: #{e.message}"
      raise "Failed to initialize SafeService: #{e.message}"
    end

    def build_multisig_tx(to_address:, value:, data:)
      safe_info = @safe.retrieve_all_info

      @safe.build_multisig_tx(
        Web3.to_checksum_address(to_address.downcase),
        value,
        HexBytes.call(data),
        safe_nonce: safe_info.nonce + 1
      )
    rescue PyCall::PyError => e
      Rails.logger.error "SafeService Build Transaction Error: #{e.message}"
      raise "Failed to build multisig transaction: #{e.message}"
    end

    def sign_transaction(safe_tx, private_key)
      safe_tx.sign(private_key)
      safe_tx
    rescue PyCall::PyError => e
      Rails.logger.error "SafeService Sign Transaction Error: #{e.message}"
      raise "Failed to sign transaction: #{e.message}"
    end

    def post_transaction(safe_tx)
      @transaction_service_api.post_transaction(safe_tx)
    rescue PyCall::PyError => e
      Rails.logger.error "SafeService Post Transaction Error: #{e.message}"
      raise "Failed to post transaction: #{e.message}"
    end

    private

    def validate_safe_address!
      unless valid_ethereum_address?(@safe_address)
        raise ArgumentError, "Invalid SAFE_ADDRESS: #{@safe_address}"
      end
    end

    def valid_ethereum_address?(address)
      address.match?(/\A0x[a-fA-F0-9]{40}\z/)
    end
  end
end
