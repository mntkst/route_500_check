# lib/route_500_check/reporter/json.rb

require "json"
require "time"

module Route500Check
  module Reporter
    class Json
      DEFAULT_OUTPUT_PATH = "route500check.json"

      def self.write(results:, summary:, output_path: nil)
        payload = build_payload(results: results, summary: summary)
        File.write(output_path || DEFAULT_OUTPUT_PATH, JSON.pretty_generate(payload))
      end

      private

      def self.build_payload(results:, summary:)
        {
          generated_at: Time.now.utc.iso8601,
          summary: summary,
          results: results
        }
      end
    end
  end
end
