module Notifications
  class OnTemplateCreated
    def call(event)
      template_id = event.data.fetch(:template_id)
      name = event.data.fetch(:name)
      content = event.data.fetch(:content)
      template_type = event.data.fetch(:template_type)

      NotificationTemplateReadModel.find_or_create_by(template_id: template_id).update(
        name: name,
        content: content,
        template_type: template_type
      )
    end
  end
end
