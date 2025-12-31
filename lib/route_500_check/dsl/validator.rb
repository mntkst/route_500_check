# lib/route_500_check/dsl/validator.rb
module Route500Check
  class DSL::Validator
    def self.validate!(config)
      expanded =
        RouteParamBuilder.expand(
          config.routes,
          config.default_limit
        )

      total = expanded.size
      limit = config.default_limit

      return unless limit
      return if total <= limit

      raise Route500Check::Errors::RouteLimitExceeded.new(
        actual: total,
        limit: limit
      )
    end
  end
end
