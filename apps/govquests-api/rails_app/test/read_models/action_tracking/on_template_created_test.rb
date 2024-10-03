require "test_helper"

module Notifications
  class OnTemplateCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = OnTemplateCreated.new
      @template_id = SecureRandom.uuid
      @name = "Welcome Email"
      @content = "Welcome to our platform!"
      @template_type = "email"
    end

    test "creates a new notification template when handling NotificationTemplateCreated event" do
      event = NotificationTemplateCreated.new(data: {
        template_id: @template_id,
        name: @name,
        content: @content,
        template_type: @template_type
      })

      assert_difference "NotificationTemplateReadModel.count", 1 do
        @handler.call(event)
      end

      template = NotificationTemplateReadModel.find_by(template_id: @template_id)
      assert_equal @name, template.name
      assert_equal @content, template.content
      assert_equal @template_type, template.template_type
    end
  end
end
