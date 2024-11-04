require_relative "transaction_encoder"
require_relative "client"
require_relative "ethereum_client"

module Safe
  class ProposeErc20Transfer
    include ActiveModel::Validations
    RPC_URL = Rails.application.credentials.dig(:safe_integration, :rpc_url)
    SAFE_ADDRESS = Rails.application.credentials.dig(:safe_integration, :safe_address)
    SYSTEM_PRIVATE_KEY = Rails.application.credentials.dig(:safe_integration, :system_private_key)
    NETWORK = Rails.application.credentials.dig(:safe_integration, :network) || "SEPOLIA"

    attr_reader :to_address, :value, :token_address

    validates :to_address, :value, :token_address, presence: true

    def initialize(
      to_address:,
      value:,
      token_address:
    )
      @to_address = to_address
      @value = value
      @token_address = token_address

      validate_env_variables!

      @ethereum_client = EthereumClient.new(
        rpc_url: RPC_URL,
        network: NETWORK
      )

      @safe = Safe::Client.new(
        safe_address: SAFE_ADDRESS,
        ethereum_client: @ethereum_client.ethereum_client,
        network: @ethereum_client.network
      )

      @transaction_encoder = TransactionEncoder.new(
        rpc_url: RPC_URL
      )
    end

    def call
      signed_tx = @safe.sign_transaction(safe_tx, SYSTEM_PRIVATE_KEY)

      @safe.post_transaction(signed_tx)
    rescue => e
      raise "Transaction failed: #{e.message}"
    end

    private

    def tx_data
      @tx_data ||= @transaction_encoder.encode_erc20_transfer(
        token_address: token_address,
        to_address: to_address,
        # TODO: fix issue with long long value overflowing in Python
        value: value * 10**18
      )
    end

    def safe_tx
      @safe_tx ||= @safe.build_multisig_tx(
        to_address: token_address,
        value: 0,
        data: tx_data
      )
    end

    def validate_env_variables!
      missing_vars = []
      missing_vars << "RPC_URL" unless RPC_URL
      missing_vars << "SAFE_ADDRESS" unless SAFE_ADDRESS
      missing_vars << "SYSTEM_PRIVATE_KEY" unless SYSTEM_PRIVATE_KEY

      unless missing_vars.empty?
        raise ArgumentError, "Missing environment variables: #{missing_vars.join(", ")}"
      end
    end
  end
end
