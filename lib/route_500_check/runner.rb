# lib/route_500_check/runner.rb

require "route_500_check/route_param_builder"
require "route_500_check/only_public_builder"

module Route500Check
  class Runner
    EXIT_OK  = 0
    EXIT_500 = 2

    def self.run(_options = {})
      config = DSL.load!

      runtime_base_url =
        ENV["ROUTE500CHECK_BASE_URL"] ||
        config.base_url

      unless runtime_base_url
        abort "[route_500_check] base_url is required (ENV or DSL)"
      end

      puts "[route_500_check] base_url=#{runtime_base_url}"

      checker = Checker.new(runtime_base_url)

      # ---- route expansion ----
      paths =
        RouteParamBuilder.expand(
          config.routes,
          config.default_limit
        )

      # ---- ONLY=public ----
      if ENV["ONLY"] == "public"
        paths =
          OnlyPublicBuilder.filter(
            paths,
            config.only_public_prefixes
          )
      end

      # ---- execute ----
      results = []

      paths.each do |path|
        result = checker.check(path)
        results << result

        if result[:error]
          puts "[route_500_check] ERROR #{result[:url]} #{result[:error]}"
        else
          puts "[route_500_check] GET #{result[:url]} -> #{result[:status]} (#{result[:elapsed_ms]}ms)"
        end
      end

      # ---- summary ----
      summary = build_summary(results)
      print_summary(summary)

      ignored = config.ignore_status || []

      has_500 = results.any? do |r|
        s = r[:status]
        s && s >= 500 && !ignored.include?(s)
      end

      Reporter::Json.write(
        results: results,
        summary: summary
      )

      exit(has_500 ? EXIT_500 : EXIT_OK)
    end

    # ==========
    # summary helpers
    # ==========
    def self.print_summary(s)
      puts "[route_500_check] Result summary:"
      puts "  total_routes: #{s[:total_routes]}"
      puts "  success:      #{s[:success]}"
      puts "  errors:       #{s[:errors]}"
      puts "  http_2xx:     #{s[:http_2xx]}"
      puts "  http_3xx:     #{s[:http_3xx]}"
      puts "  http_4xx:     #{s[:http_4xx]}"
      puts "  http_5xx:     #{s[:http_5xx]}"
      puts "  max_latency:  #{s[:max_latency_ms] ? "#{s[:max_latency_ms]}ms" : '-'}"
      puts "  avg_latency:  #{s[:avg_latency_ms] ? "#{s[:avg_latency_ms]}ms" : '-'}"
    end

    def self.build_summary(results)
      total = results.size

      error_count = results.count { |r| r[:error] }

      statuses = results.map { |r| r[:status] }.compact

      http_2xx = statuses.count { |s| s >= 200 && s < 300 }
      http_3xx = statuses.count { |s| s >= 300 && s < 400 }
      http_4xx = statuses.count { |s| s >= 400 && s < 500 }
      http_5xx = statuses.count { |s| s >= 500 }

      http_4xx_breakdown =
        statuses
          .select { |s| s >= 400 && s < 500 }
          .tally
          .transform_keys(&:to_s)

      success = total - error_count - http_5xx

      elapsed = results.map { |r| r[:elapsed_ms] }.compact

      {
        total_routes: total,
        success: success,
        errors: error_count,

        http_2xx: http_2xx,
        http_3xx: http_3xx,
        http_4xx: http_4xx,
        http_5xx: http_5xx,

        http_4xx_breakdown: http_4xx_breakdown,

        max_latency_ms: elapsed.max,
        avg_latency_ms: elapsed.any? ? (elapsed.sum / elapsed.size.to_f).round(1) : nil
      }
    end
  end
end
