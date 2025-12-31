# executor/request_runner.rb
module Route500Check::Executor
  class RequestRunner
    def self.run(routes, config)
      routes.flat_map do |route|
        route.expanded_paths.map do |path|
          run_one(path, config)
        end
      end
    end
  end
end
