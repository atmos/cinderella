# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cinderella/version"

Gem::Specification.new do |s|
  s.name        = "cinderella"
  s.version     = Cinderella::VERSION
  s.authors     = ["Corey Donohoe"]
  s.email       = ["atmos@atmos.org"]
  s.homepage    = "https://github.com/atmos/cinderella"
  s.summary     = %q{The development environment you never wanted to manage alone}
  s.description = %q{The development environment you never wanted to manage alone}

  s.rubyforge_project = "cinderella"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
