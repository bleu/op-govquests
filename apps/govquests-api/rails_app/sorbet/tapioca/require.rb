# typed: strong
# frozen_string_literal: true

require "action_controller/railtie"
require "action_mailbox/engine"
require "action_mailer/railtie"
require "action_text/engine"
require "action_view/railtie"
require "active_job/railtie"
require "active_model/railtie"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/railtie"
require "active_storage/engine"
require "active_support/core_ext/integer/time"
require "aggregate_root"
require "arkency/command_bus"
require "bootsnap/setup"
require "bundler/setup"
require "factory_bot_rails"
require "httparty"
require "json"
require "mutant/minitest/coverage"
require "rails"
require "rails/test_unit/railtie"
require "rspec/rails"
require "securerandom"
require_relative "../../lib/read_models_configuration"

loader = Zeitwerk::Loader.new
loader.setup
loader.eager_load
