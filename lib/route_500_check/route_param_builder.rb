# lib/route_500_check/route_param_builder.rb

module Route500Check
  class RouteParamBuilder
    # ======================
    # DSL 用
    # ======================
    def initialize(params)
      @params = params
    end

    def sample(n)
      @params[:__sample__] = n
    end

    def limit(n)
      @params[:__limit__] = n
    end

    def method_missing(name, *args, &block)
      @params[name.to_sym] =
        if args.length <= 1
          args.first
        else
          args
        end
    end

    def respond_to_missing?(_name, _include_private = false)
      true
    end

    # ======================
    # 実行用（Runner が呼ぶ）
    # ======================
    def self.expand(route_defs, default_limit)
      route_defs.flat_map do |route|
        template = route.template
        params   = route.params || {}

        placeholders =
          template.scan(/:(\w+)/).flatten.map(&:to_sym)

        # placeholder が無い場合
        if placeholders.empty?
          paths = [template]
        else
          values_map =
            placeholders.map do |key|
              raw = params[key]
              values =
                case raw
                when Range
                  raw.to_a
                when Array
                  raw.flat_map { |v| v.is_a?(Range) ? v.to_a : v }
                else
                  [raw]
                end

              [key, values]
            end.to_h

          combinations = cartesian_product(values_map)

          # sample
          if params[:__sample__]
            combinations = combinations.sample(params[:__sample__])
          end

          # limit（route → global の順で適用）
          route_limit  = params[:__limit__]
          global_limit = default_limit

          effective_limit =
            if route_limit && global_limit
              [route_limit, global_limit].min
            else
              route_limit || global_limit
            end

          if effective_limit
            combinations = combinations.take(effective_limit)
          end

          paths =
            combinations.map do |combo|
              path = template.dup
              combo.each { |k, v| path.sub!(":#{k}", v.to_s) }
              path
            end
        end

        paths
      end
    end

    def self.cartesian_product(values_map)
      keys   = values_map.keys
      values = values_map.values

      values
        .shift
        .product(*values)
        .map { |combo| keys.zip(combo).to_h }
    end
  end
end
