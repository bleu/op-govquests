module Notifications
  class OnTemplateDeleted
    def call(event)
      template_id = event.data.fetch(:template_id)

      template = NotificationTemplateReadModel.find_by(template_id: template_id)
      template&.destroy
    end
  end
end
