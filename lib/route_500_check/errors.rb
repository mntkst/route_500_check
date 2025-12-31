module Route500Check
  module Errors
    class RouteLimitExceeded < StandardError
      attr_reader :actual, :limit

      def initialize(actual:, limit:)
        @actual = actual
        @limit  = limit
        super(build_message)
      end

      private

      def build_message
        <<~MSG.strip
          Route expansion exceeded safety limit.
          - expanded routes: #{actual}
          - default_limit:   #{limit}

          This is NOT a runtime error.
          Adjust default_limit or route sample/limit settings.
        MSG
      end
    end
  end
end
