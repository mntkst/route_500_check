# lib/route_500_check.rb

require "route_500_check/version"

# DSL 関連
require "route_500_check/route_param_builder"
require "route_500_check/only_public_builder"
require "route_500_check/dsl"
require "route_500_check/dsl/validator"
require "route_500_check/errors"

# 実行系
require "route_500_check/checker"
require "route_500_check/reporter/json"
require "route_500_check/runner"
require "route_500_check/cli"

module Route500Check
  def self.define(&block)
    DSL.current ||= DSL.new
    DSL.current.instance_eval(&block)
  end

  def self.run
    CLI.new.run
  end
end

if defined?(Rails)
  require "route_500_check/railtie"
end
