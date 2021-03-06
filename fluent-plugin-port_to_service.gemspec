lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-port_to_service"
  spec.version = "0.1.3"
  spec.authors = ["Chris Pedro"]
  spec.email   = ["chris@thepedros.com"]

  spec.summary       = %q{Fluentd filter plugin to include TCP/UDP services based on port information.}
  spec.description   = %q{Filter plugin to include TCP/UDP services.}
  spec.homepage      = "https://github.com/cpedro/fluent-plugin-port_to_service.git"
  spec.license       = "Unlicense"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency "sqlite3", "~> 1.3"

  spec.executables << "fluent-plugin-port_to_service_build_db"
end
