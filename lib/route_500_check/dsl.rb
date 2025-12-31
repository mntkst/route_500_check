# lib/route_500_check/dsl.rb
require "route_500_check/route_param_builder"
require "route_500_check/only_public_builder"

module Route500Check
  RouteDef = Struct.new(:template, :params)

  class DSL
    CONFIG_PATH = "config/route_500_check.rb"

    class << self
      attr_accessor :current
    end

    attr_reader :routes, :ignore_statuses

    def initialize
      @routes               = []
      @default_limit        = nil
      @ignore_statuses      = []
      @only_public_prefixes = nil
      @base_url             = nil
    end

    # ==========
    # Load config
    # ==========
    def self.load!
      unless File.exist?(CONFIG_PATH)
        raise <<~MSG
          [route_500_check] Config file not found: #{CONFIG_PATH}

          Please run:
              rails generate route500_check:install
        MSG
      end

      self.current = new

      begin
        DSL.current.instance_eval(File.read(CONFIG_PATH))
      rescue Exception => e
        raise "[route_500_check] Failed to load config: #{e.message}"
      end

      current
    end

    # ==========
    # Global settings
    # ==========
    def base_url(value = nil)
      value ? (@base_url = value) : @base_url
    end

    def default_limit(value = nil)
      value ? (@default_limit = value) : @default_limit
    end

    def ignore_status(values = nil)
      if values
        @ignore_statuses = Array(values).map(&:to_i)
      else
        @ignore_statuses
      end
    end

    # ==========
    # ONLY=public DSL
    # ==========
    def only_public(&block)
      builder = ::Route500Check::OnlyPublicBuilder.new
      builder.instance_eval(&block)
      @only_public_prefixes = builder.prefixes
    end

    def only_public_prefixes
      @only_public_prefixes
    end

    # ==========
    # route DSL
    # ==========
    def route(path, &block)
      params = {}

      if block
        builder = ::Route500Check::RouteParamBuilder.new(params)
        builder.instance_eval(&block)
      end

      @routes << RouteDef.new(path, params)
    end
  end
end
