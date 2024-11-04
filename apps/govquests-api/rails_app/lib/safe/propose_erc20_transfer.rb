module Safe
  class ProposeErc20Transfer
    attr_reader :to_address, :value, :token_address

    def initialize(to_address:, value:, token_address:)
      @to_address = to_address
      @value = value
      @token_address = token_address

      validate_env_variables!
      initialize_services
    end

    def call
      return {error: errors.full_messages.join(", ")} unless valid?

      signed_tx = sign_transaction

      post_transaction(signed_tx)

      {success: true, safe_tx_hash: signed_tx.safe_tx_hash}
    rescue => e
      {error: "Transaction failed: #{e.message}"}
    end

    private

    def initialize_services
      @ethereum_client = Safe::EthereumClient.new(
        rpc_url: Safe::Configuration.rpc_url,
        network: Safe::Configuration.network || "SEPOLIA"
      )

      @safe_client = Safe::Client.new(
        safe_address: Safe::Configuration.safe_address,
        ethereum_client: @ethereum_client.ethereum_client,
        network: @ethereum_client.network
      )

      @transaction_encoder = Safe::TransactionEncoder.new(
        rpc_url: Safe::Configuration.rpc_url
      )
    end

    def tx_data
      @tx_data ||= @transaction_encoder.encode_erc20_transfer(
        token_address: token_address,
        to_address: to_address,
        value: value
      )
    end

    def safe_tx
      @safe_tx ||= @safe_client.build_multisig_tx(
        to_address: token_address,
        value: 0,
        data: tx_data
      )
    end

    def sign_transaction
      safe_tx = self.safe_tx
      safe_tx.sign(Safe::Configuration.system_private_key)
      safe_tx
    end

    def post_transaction(safe_tx)
      @safe_client.post_transaction(safe_tx)
    end

    def validate_env_variables!
      missing_vars = []
      missing_vars << "SAFE_INTEGRATION_RPC_URL" unless Safe::Configuration.rpc_url
      missing_vars << "SAFE_INTEGRATION_SAFE_ADDRESS" unless Safe::Configuration.safe_address
      missing_vars << "SAFE_INTEGRATION_SYSTEM_PRIVATE_KEY" unless Safe::Configuration.system_private_key

      unless missing_vars.empty?
        raise ArgumentError, "Missing environment variables: #{missing_vars.join(", ")}"
      end
    end
  end
end
