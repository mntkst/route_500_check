module Route500Check
  class Railtie < Rails::Railtie
    railtie_name :route_500_check

    generators do
      require_relative "../generators/route_500_check/install_generator"
    end
  end
end
