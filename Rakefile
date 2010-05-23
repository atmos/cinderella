require 'rake/gempackagetask'
require 'rubygems/specification'
require 'bundler'

GEM         = "cider"
GEM_VERSION = "0.1.0"
AUTHOR      = "Corey Donohoe"
EMAIL       = "atmos@atmos.org"
HOMEPAGE    = "http://github.com/atmos/cider"
SUMMARY     = "The development environment you never wanted to manage alone"

spec = Gem::Specification.new do |s|
  s.name             = GEM
  s.version          = GEM_VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["LICENSE"]
  s.summary          = SUMMARY
  s.description      = s.summary
  s.author           = AUTHOR
  s.email            = EMAIL
  s.homepage         = HOMEPAGE

  bundle = Bundler::Definition.from_gemfile('Gemfile')
  bundle.dependencies.each do |dep|
    next unless dep.groups.include?(:runtime)
    s.add_dependency(dep.name, dep.version_requirements.to_s)
  end

  s.bindir       = "bin"
  s.executables  = %w( cider )
  s.require_path = 'lib'
  s.files        = %w(LICENSE README.md Rakefile) + Dir.glob("{lib}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
