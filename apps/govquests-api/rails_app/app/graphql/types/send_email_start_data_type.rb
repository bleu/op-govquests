module Types
  class SendEmailStartDataType < Types::BaseObject
    implements Types::StartDataInterface
    description "Start data for send email action"

    field :email, String, null: false

    def action_type
      "send_email"
    end
  end
end
