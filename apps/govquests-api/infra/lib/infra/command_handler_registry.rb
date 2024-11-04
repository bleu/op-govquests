module Infra
  class CommandHandlerRegistry
    class << self
      def handle(command_name, aggregate:, &block)
        handlers[command_name] = {
          aggregate: aggregate,
          handler: block
        }
      end

      def register_commands(event_store, command_bus)
        handler = new(AggregateRootRepository.new(event_store))
        handlers.each_key do |command_name|
          if command_name.is_a?(String)
            command_class = Object.const_get(command_name)
            command_bus.register(command_class, handler)
          elsif command_name.is_a?(Symbol)
            module_name = name.deconstantize
            full_command_name = "#{module_name}::#{command_name}"
            command_class = Object.const_get(full_command_name)
            command_bus.register(command_class, handler)
          end
        end
      end

      protected

      def handlers
        @handlers ||= {}
      end
    end

    def initialize(repository)
      @repository = repository
    end

    def call(command)
      # Try fully qualified name first
      command_name = command.class.name
      command_config = self.class.send(:handlers)[command_name]

      # Fall back to short name if not found
      if command_config.nil?
        short_name = command.class.name.demodulize
        command_config = self.class.send(:handlers)[short_name.to_sym]
      end

      raise "Handler not found for command: #{command_name}" if command_config.nil?

      @repository.with_aggregate(command_config[:aggregate], command.aggregate_id) do |aggregate|
        command_config[:handler].call(aggregate, command, @repository)
      end
    end
  end
end
