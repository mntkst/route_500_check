# lib/route_500_check/checker.rb

require "net/http"
require "uri"

module Route500Check
  class Checker
    def initialize(base_url)
      @base_url = base_url
    end

    def check(path)
      uri   = build_uri(path)
      start = now

      response = Net::HTTP.get_response(uri)
      finish   = now

      build_success_result(
        path: path,
        uri: uri,
        response: response,
        start: start,
        finish: finish
      )
    rescue => e
      finish = now rescue nil

      build_error_result(
        path: path,
        uri: uri,
        error: e,
        start: start,
        finish: finish
      )
    end

    private

    def build_uri(path)
      URI.join(@base_url, path)
    end

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def elapsed_ms(start, finish)
      return nil unless start && finish
      ((finish - start) * 1000).round(1)
    end

    def build_success_result(path:, uri:, response:, start:, finish:)
      {
        path: path,
        url: uri.to_s,
        status: response.code.to_i,
        elapsed_ms: elapsed_ms(start, finish)
      }
    end

    def build_error_result(path:, uri:, error:, start:, finish:)
      {
        path: path,
        url: uri.to_s,
        error: error.message,
        elapsed_ms: elapsed_ms(start, finish)
      }
    end
  end
end
