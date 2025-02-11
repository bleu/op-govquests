require "dry/container"
require "dry/auto_inject"

module Gamification
  class Container
    extend Dry::Container::Mixin
  end

  Import = Dry::AutoInject(Container)
end
