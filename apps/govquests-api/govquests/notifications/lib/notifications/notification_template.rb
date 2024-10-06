module Notifications
  class NotificationTemplate
    include AggregateRoot

    def initialize(id)
      @id = id
      @name = nil
      @content = nil
      @type = nil
    end

    def create(name, content, type)
      apply NotificationTemplateCreated.new(data: {
        template_id: @id,
        name: name,
        content: content,
        type: type
      })
    end

    def update(name: nil, content: nil, type: nil)
      apply NotificationTemplateUpdated.new(data: {
        template_id: @id,
        name: name,
        content: content,
        type: type
      })
    end

    def delete
      apply NotificationTemplateDeleted.new(data: {
        template_id: @id
      })
    end

    private

    on NotificationTemplateCreated do |event|
      @name = event.data[:name]
      @content = event.data[:content]
      @type = event.data[:type]
    end

    on NotificationTemplateUpdated do |event|
      @name = event.data[:name] if event.data[:name]
      @content = event.data[:content] if event.data[:content]
      @type = event.data[:type] if event.data[:type]
    end

    on NotificationTemplateDeleted do |_event|
      @deleted = true
    end
  end
end
