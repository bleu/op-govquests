require "test_helper"

class ReadModelHandlerTest < InMemoryTestCase
  cover "ReadModelHandler*"
  cover "CreateRecord*"
  cover "CopyEventAttribute*"

  private

  def read_model
    SingleTableReadModel.new(event_store, PublicOffer::Product, :product_id)
  end

  def event_store
    Rails.configuration.event_store
  end
end
