require "dry/container"
require "dry/auto_inject"

module Infra
  class Container
    extend Dry::Container::Mixin
  end

  Import = Dry::AutoInject(Container)
end
