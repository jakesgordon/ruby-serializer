# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("lib", File.dirname(__FILE__))
require 'ruby-serializer'

Gem::Specification.new do |s|

  s.name        = "ruby-serializer"
  s.version     = RubySerializer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jake Gordon"]
  s.email       = ["jake@codeincomplete.com"]
  s.homepage    = "https://github.com/jakesgordon/ruby-serializer"
  s.summary     = RubySerializer::SUMMARY
  s.description = RubySerializer::DESCRIPTION

  s.has_rdoc         = false
  s.extra_rdoc_files = ["readme.md"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.files            = `git ls-files `.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]

end
