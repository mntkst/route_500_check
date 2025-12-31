# dsl/route_definition.rb
Route = Struct.new(:path, :expanded_paths, :limit)

module Route500Check::DSL
  class RouteDefinition
    def self.load
      # DSLを読み、placeholder展開済みの Route を返す
    end
  end
end
