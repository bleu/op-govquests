module Gamification
  class OnBadgeCreated
    def call(event)
      badgeable_model_name = "Questing::" + event.data[:badgeable_type] + "ReadModel"

      id_column = (event.data[:badgeable_type].underscore + "_id").to_sym
      badgeable_id = badgeable_model_name.constantize.where({id_column => event.data[:badgeable_id]}).take.id
      badge = BadgeReadModel.find_or_initialize_by(badge_id: event.data[:badge_id])
      badge.update!(
        display_data: event.data[:display_data],
        badgeable_type: badgeable_model_name,
        badgeable_id: badgeable_id
      )
    end
  end
end
