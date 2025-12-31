# lib/route_500_check/only_public_builder.rb

module Route500Check
  class OnlyPublicBuilder
    DEFAULT_EXCLUDE_PREFIXES = %w[
      /admin
      /api
      /internal
      /rails
      /assets
      /health
    ].freeze

    # ======================
    # DSL 用（既存仕様そのまま）
    # ======================
    def initialize
      @prefixes = []
    end

    def exclude_prefix(prefix)
      @prefixes << prefix
    end

    def prefixes
      @prefixes
    end

    # ======================
    # 実行用（Runner から利用）
    # ======================
    def self.filter(paths, prefixes = nil)
      effective_prefixes =
        if prefixes && !prefixes.empty?
          prefixes
        else
          DEFAULT_EXCLUDE_PREFIXES
        end

      paths.reject do |path|
        effective_prefixes.any? { |prefix| path.start_with?(prefix) }
      end
    end
  end
end
