Gem::Specification.new do |spec|
  spec.name          = "route_500_check"
  spec.version       = "0.2.0"
  spec.authors       = ["mntkst"]
  spec.summary       = "Detect HTTP 500 errors by scanning selected Rails routes"
  spec.description   = "DSL-based HTTP 500 error detector for Rails applications"
  spec.homepage      = "https://github.com/example/route_500_check"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "exe/*", "bin/*", "README.md", "LICENSE"]
  spec.executables   = ["route500check"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => spec.homepage + "/releases"
  }
end
