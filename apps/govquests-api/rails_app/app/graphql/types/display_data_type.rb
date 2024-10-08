module Types
  class DisplayDataType < Types::BaseObject
    field :title, String, null: true
    field :intro, String, null: true
    field :content, String, null: true
    field :image_url, String, null: true
  end
end
