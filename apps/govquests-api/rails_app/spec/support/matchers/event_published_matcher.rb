RSpec::Matchers.define :have_published do |expected_event|
  match do |event_store|
    @events = event_store.read.to_a
    @events.any? { |event| expected_event.matches?(event) }
  end

  failure_message do |_|
    "expected to have published:\n#{expected_event.description}\nbut published:\n#{@events.map(&:event_type).join("\n")}"
  end
end

RSpec::Matchers.define :an_event do |expected_class|
  match do |actual_event|
    actual_event.is_a?(expected_class) && (@expected_data.nil? || actual_event.data == @expected_data)
  end

  chain :with_data do |expected_data|
    @expected_data = expected_data
  end

  description do
    "an event #{expected_class} with data #{@expected_data}"
  end
end
