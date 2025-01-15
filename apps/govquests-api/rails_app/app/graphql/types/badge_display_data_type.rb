module Types
  class BadgeDisplayDataType < Types::BaseObject
    field :title, String, null: true
    field :description, String, null: true
    field :image_url, String, null: true
    field :source, String, null: true
  end
end
