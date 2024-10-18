module Types
  class EnsStartDataInput < BaseInputObject
    description "Start data for ENS action"

    argument :address, String, required: true
  end
end
