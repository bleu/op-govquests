class SingleTableReadModel
  def initialize(event_store, active_record_name, id_column)
    @event_store = event_store
    @active_record_name = active_record_name
    @id_column = id_column
  end

  def subscribe_create(creation_event)
    @event_store.subscribe(create_handler(creation_event), to: [creation_event])
  end

  def subscribe_copy(event, sequence_of_keys, column = Array(sequence_of_keys).join("_"))
    @event_store.subscribe(copy_handler(event, sequence_of_keys, column), to: [event])
  end

  private

  def create_handler(event)
    handler_class_name = "Create#{@active_record_name.name.gsub("::", "")}On#{event.name.gsub("::", "")}"
    Object.send(:remove_const, handler_class_name) if self.class.const_defined?(handler_class_name)
    _active_record_name_, _id_column_, _event_store_ = @active_record_name, @id_column, @event_store
    Object.const_set(
      handler_class_name,
      Class.new(CreateRecord) do
        define_method(:event_store) { _event_store_ }
        define_method(:active_record_name) { _active_record_name_ }
        define_method(:id_column) { _id_column_ }
      end
    )
  end

  def copy_handler(event, sequence_of_keys, column)
    handler_class_name = "Set#{@active_record_name.name.gsub("::", "")}#{column.to_s.camelcase}On#{event.name.gsub("::", "")}"
    Object.send(:remove_const, handler_class_name) if self.class.const_defined?(handler_class_name)
    _active_record_name_, _id_column_, _event_store_ = @active_record_name, @id_column, @event_store
    Object.const_set(
      handler_class_name,
      Class.new(CopyEventAttribute) do
        define_method(:event_store) { _event_store_ }
        define_method(:active_record_name) { _active_record_name_ }
        define_method(:id_column) { _id_column_ }
        define_method(:sequence_of_keys) { sequence_of_keys }
        define_method(:column) { column }
      end
    )
  end
end

class ReadModelHandler
  def initialize(event_store, active_record_name, id_column)
    @event_store = event_store
    @active_record_name = active_record_name
    @id_column = id_column
  end

  private

  attr_reader :active_record_name, :id_column, :event_store

  # Concurrency-safe block for handling events
  def concurrent_safely(event)
    stream_name = "#{active_record_name}$#{record_id(event)}$#{event.event_type}"
    ApplicationRecord.with_advisory_lock(active_record_name, record_id(event)) do
      yield
      link_event_to_stream(event, stream_name)
    end
  rescue RubyEventStore::WrongExpectedEventVersion, RubyEventStore::EventDuplicatedInStream
    Rails.logger.warn "Event #{event.event_id} is already processed in stream #{stream_name}"
  end

  def find_or_initialize_record(event)
    active_record_name.find_or_initialize_by(id: record_id(event))
  end

  def record_id(event)
    event.data.fetch(id_column)
  end

  # Links the event to a stream for consistency
  def link_event_to_stream(event, stream_name)
    event_store.link(event.event_id, stream_name: stream_name)
  end
end

class CreateRecord < ReadModelHandler
  def call(event)
    concurrent_safely(event) do
      find_or_initialize_record(event).save!
    end
  end
end

class CopyEventAttribute < ReadModelHandler
  def initialize(event_store, active_record_name, id_column, sequence_of_keys, column)
    super(event_store, active_record_name, id_column)
    @sequence_of_keys = sequence_of_keys
    @column = column
  end

  def call(event)
    concurrent_safely(event) do
      find_or_initialize_record(event).update_attribute(column, event.data.dig(*sequence_of_keys))
    end
  end

  private

  attr_reader :sequence_of_keys, :column
end
