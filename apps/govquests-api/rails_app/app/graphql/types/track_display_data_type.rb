module Types
  class TrackDisplayDataType < Types::BaseObject
    field :title, String, null: false
    field :description, String, null: false
    field :background_gradient, Types::BackgroundGradient, null: false
  end
end
