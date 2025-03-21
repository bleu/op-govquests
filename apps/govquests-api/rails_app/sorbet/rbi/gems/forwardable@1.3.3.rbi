# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `forwardable` gem.
# Please instead update this file by running `bin/tapioca gem forwardable`.


# :stopdoc:
module Forwardable
  # Define +method+ as delegator instance method with an optional
  # alias name +ali+. Method calls to +ali+ will be delegated to
  # +accessor.method+.  +accessor+ should be a method name, instance
  # variable name, or constant name.  Use the full path to the
  # constant if providing the constant name.
  # Returns the name of the method defined.
  #
  #   class MyQueue
  #     CONST = 1
  #     extend Forwardable
  #     attr_reader :queue
  #     def initialize
  #       @queue = []
  #     end
  #
  #     def_delegator :@queue, :push, :mypush
  #     def_delegator 'MyQueue::CONST', :to_i
  #   end
  #
  #   q = MyQueue.new
  #   q.mypush 42
  #   q.queue    #=> [42]
  #   q.push 23  #=> NoMethodError
  #   q.to_i     #=> 1
  #
  # source://forwardable//forwardable.rb#188
  def def_delegator(accessor, method, ali = T.unsafe(nil)); end

  # Shortcut for defining multiple delegator methods, but with no
  # provision for using a different name.  The following two code
  # samples have the same effect:
  #
  #   def_delegators :@records, :size, :<<, :map
  #
  #   def_delegator :@records, :size
  #   def_delegator :@records, :<<
  #   def_delegator :@records, :map
  #
  # source://forwardable//forwardable.rb#156
  def def_delegators(accessor, *methods); end

  # Define +method+ as delegator instance method with an optional
  # alias name +ali+. Method calls to +ali+ will be delegated to
  # +accessor.method+.  +accessor+ should be a method name, instance
  # variable name, or constant name.  Use the full path to the
  # constant if providing the constant name.
  # Returns the name of the method defined.
  #
  #   class MyQueue
  #     CONST = 1
  #     extend Forwardable
  #     attr_reader :queue
  #     def initialize
  #       @queue = []
  #     end
  #
  #     def_delegator :@queue, :push, :mypush
  #     def_delegator 'MyQueue::CONST', :to_i
  #   end
  #
  #   q = MyQueue.new
  #   q.mypush 42
  #   q.queue    #=> [42]
  #   q.push 23  #=> NoMethodError
  #   q.to_i     #=> 1
  #
  # source://forwardable//forwardable.rb#188
  def def_instance_delegator(accessor, method, ali = T.unsafe(nil)); end

  # Shortcut for defining multiple delegator methods, but with no
  # provision for using a different name.  The following two code
  # samples have the same effect:
  #
  #   def_delegators :@records, :size, :<<, :map
  #
  #   def_delegator :@records, :size
  #   def_delegator :@records, :<<
  #   def_delegator :@records, :map
  #
  # source://forwardable//forwardable.rb#156
  def def_instance_delegators(accessor, *methods); end

  # Takes a hash as its argument.  The key is a symbol or an array of
  # symbols.  These symbols correspond to method names, instance variable
  # names, or constant names (see def_delegator).  The value is
  # the accessor to which the methods will be delegated.
  #
  # :call-seq:
  #    delegate method => accessor
  #    delegate [method, method, ...] => accessor
  #
  # source://forwardable//forwardable.rb#135
  def delegate(hash); end

  # Takes a hash as its argument.  The key is a symbol or an array of
  # symbols.  These symbols correspond to method names, instance variable
  # names, or constant names (see def_delegator).  The value is
  # the accessor to which the methods will be delegated.
  #
  # :call-seq:
  #    delegate method => accessor
  #    delegate [method, method, ...] => accessor
  #
  # source://forwardable//forwardable.rb#135
  def instance_delegate(hash); end

  class << self
    # source://forwardable//forwardable/impl.rb#11
    def _compile_method(src, file, line); end

    # source://forwardable//forwardable.rb#203
    def _delegator_method(obj, accessor, method, ali); end

    # @return [Boolean]
    #
    # source://forwardable//forwardable/impl.rb#3
    def _valid_method?(method); end

    # ignored
    #
    # source://forwardable//forwardable.rb#123
    def debug; end

    # ignored
    #
    # source://forwardable//forwardable.rb#123
    def debug=(_arg0); end
  end
end

# Version of +forwardable.rb+
#
# source://forwardable//forwardable.rb#115
Forwardable::VERSION = T.let(T.unsafe(nil), String)
