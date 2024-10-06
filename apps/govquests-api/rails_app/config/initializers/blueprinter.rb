# typed: strict
# frozen_string_literal: true

# https://github.com/ohler55/oj/blob/develop/pages/Rails.md
Oj.optimize_rails

Blueprinter.configure do |config|
  config.generator = Oj # default is JSON
end
