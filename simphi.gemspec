# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "simphi"
  spec.version       = "0.0.2"
  spec.authors       = ["Alex Beznos"]
  spec.email         = ["beznosa@yahoo.com"]
  spec.summary       = %q{Ability to deale with hash like inputs}
  spec.description   = %q{The gem for natural using of hstore or any hash using in web dev}
  spec.homepage      = "https://github.com/AlexBeznos/simphi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "simple_form", "> 2.0"
  spec.add_dependency "rack", "~> 1.6.4"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
