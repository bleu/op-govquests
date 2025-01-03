module ActionTracking
  class OpTokenBalance
    include HTTParty
    base_uri "https://mainnet.optimism.io"

    def self.get_balance(address)
      clean_address = address.gsub(/\A0x/, "").downcase

      response = post("/", {
        body: {
          jsonrpc: "2.0",
          method: "eth_call",
          params: [
            {
              to: "0x4200000000000000000000000000000000000042",
              data: "0x70a08231000000000000000000000000#{clean_address}"
            },
            "latest"
          ],
          id: 1
        }.to_json,
        headers: {"Content-Type" => "application/json"}
      })

      hex_value = response["result"]
      decimal_value = hex_value.gsub(/\A0x/, "").to_i(16)
      BigDecimal(decimal_value) / BigDecimal("1e18")
    end
  end
end
