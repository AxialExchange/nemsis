# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nemsis/version"

Gem::Specification.new do |s|
  s.name        = "nemsis"
  s.version     = Nemsis::VERSION
  s.authors     = ["Guangming Cui", "Jon Kern"]
  s.email       = ["gcui@axialproject.com", "jkern@axialproject.com", "dev@axialproject.com"]
  s.homepage    = ""
  s.summary     = %q{NEMSIS Data Parser}
  s.description = %q{Parses NEMSIS (National EMS Information System) Data in XML format}

  s.rubyforge_project = "nemsis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_dependency 'activesupport' # needed for proper time parsing
  s.add_dependency 'nokogiri'
  s.add_dependency 'ruby-debug19'
  s.add_dependency 'tzinfo'
end
