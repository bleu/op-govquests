require "rails_helper"

RSpec.describe Notifications::OnTemplateCreated do
  let(:handler) { described_class.new }
  let(:template_id) { SecureRandom.uuid }
  let(:name) { "Welcome Email" }
  let(:content) { "Welcome to our platform!" }
  let(:template_type) { "email" }

  describe "#call" do
    it "creates a new notification template when handling NotificationTemplateCreated event" do
      event = Notifications::NotificationTemplateCreated.new(data: {
        template_id: template_id,
        name: name,
        content: content,
        template_type: template_type
      })

      expect {
        handler.call(event)
      }.to change(Notifications::NotificationTemplateReadModel, :count).by(1)

      template = Notifications::NotificationTemplateReadModel.find_by(template_id: template_id)
      expect(template.name).to eq(name)
      expect(template.content).to eq(content)
      expect(template.template_type).to eq(template_type)
    end
  end
end
