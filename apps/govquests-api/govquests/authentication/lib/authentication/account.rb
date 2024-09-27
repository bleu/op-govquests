module Authentication
  class Account
    include AggregateRoot

    AlreadyRegistered = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def register(address, chain_id)
      raise AlreadyRegistered if @registered

      apply AccountRegistered.new(data: { account_id: @id, address: address, chain_id: chain_id })
    end

    private

    on AccountRegistered do |event|
      @registered = true
      @address = event.data[:address]
      @chain_id = event.data[:chain_id]
    end
  end
end
