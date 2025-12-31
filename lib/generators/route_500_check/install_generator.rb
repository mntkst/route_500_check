module Route500Check
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_config
        copy_file "route_500_check.rb", "config/route_500_check.rb"
      end
    end
  end
end
