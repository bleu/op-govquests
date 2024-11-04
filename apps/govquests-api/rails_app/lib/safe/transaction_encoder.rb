# lib/services/ethereum/transaction_encoder.rb

require "pycall/import"

module Safe
  class TransactionEncoder
    Web3 = PyCall.import_module("web3").Web3

    def initialize(rpc_url:)
      @rpc_url = rpc_url
      @web3 = Web3.new(Web3.HTTPProvider.new(@rpc_url))
    rescue PyCall::PyError => e
      Rails.logger.error "TransactionEncoder Initialization Error: #{e.message}"
      raise "Failed to initialize TransactionEncoder: #{e.message}"
    end

    def encode_erc20_transfer(token_address:, to_address:, value:)
      transfer_abi = [{
        "constant" => false,
        "inputs" => [
          {"name" => "_to", "type" => "address"},
          {"name" => "_value", "type" => "uint256"}
        ],
        "name" => "transfer",
        "outputs" => [{"name" => "", "type" => "bool"}],
        "type" => "function"
      }]

      contract = @web3.eth.contract(abi: transfer_abi, address: checksum_address(token_address))

      # Encode the transfer function call
      # Using encodeABI correctly on the contract object
      tx_data = contract.encodeABI(
        fn_name: "transfer",
        args: [checksum_address(to_address), value]
      )

      Rails.logger.info "TransactionEncoder: Encoded ERC20 transfer data: #{tx_data}"

      tx_data
    rescue PyCall::PyError => e
      Rails.logger.error "TransactionEncoder Encoding Error: #{e.message}"
      raise "Failed to encode ERC20 transfer: #{e.message}"
    end

    private

    def checksum_address(address)
      Web3.to_checksum_address(address.downcase)
    end
  end
end
