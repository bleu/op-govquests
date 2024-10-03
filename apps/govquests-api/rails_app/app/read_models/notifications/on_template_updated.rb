module Notifications
  class OnTemplateUpdated
    def call(event)
      template_id = event.data.fetch(:template_id)
      name = event.data[:name]
      content = event.data[:content]
      type = event.data[:notification_type]

      template = NotificationTemplateReadModel.find_by(template_id: template_id)
      return unless template

      template.update(
        name: name || template.name,
        content: content || template.content,
        notification_type: type || template.type
      )
    end
  end
end
