# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "split/counters/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Bernard Kroes"]
  gem.email         = ["bernardkroes@gmail.com"]
  gem.summary       = %q{Split extension for counting things per experiment and alternative}
  gem.description   = %q{This gem adds counters to Split}
  gem.homepage      = "https://github.com/bernardkroes/split-counters"
  gem.license       = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "split-counters"
  gem.require_paths = ['lib']
  gem.version       = Split::Counters::VERSION

  gem.add_dependency(%q<split>, [">=  0.3.0"])

  # Development Dependencies
  gem.add_development_dependency(%q<rspec>, ["~>  2.14"])
end
