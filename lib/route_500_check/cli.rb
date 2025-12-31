# lib/route500_check/cli.rb

module Route500Check
  class CLI
    EXIT_OK  = 0
    EXIT_500 = 2

    def run
      config = DSL.load!
      DSL::Validator.validate!(config)

      Runner.run
    rescue Route500Check::Errors::RouteLimitExceeded => e
      warn "[route_500_check][CONFIG] #{e.message}"
      exit 1
    rescue => e
      warn "[route_500_check][FATAL] #{e.class}: #{e.message}"
      exit 2
    end
  end
end
