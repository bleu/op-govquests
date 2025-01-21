module Types
  class BadgeDisplayDataType < Types::BaseObject
    field :title, String, null: true
    field :description, String, null: true
    field :image_url, String, null: true
    field :sequence_number, Integer, null: true
  end
end
