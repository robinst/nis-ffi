# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require 'nis-ffi/version'

Gem::Specification.new do |s|
  s.name    = %q{nis-ffi}
  s.version = NIS::Version::STRING
  s.authors = ["Robin Stocker"]
  s.email = %q{robin@nibor.org}
  s.homepage = %q{http://github.com/robinst/nis-ffi}
  s.licenses = ["MIT"]
  s.summary = %q{NIS (YP) library using libc's libnsl through ruby-ffi}
  s.description = %q{Library for NIS (YP) queries using the libnsl library of libc through ruby-ffi.}
  s.require_paths = ["lib"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.requirements = ["libnsl (provided by libc)"]

  s.add_runtime_dependency 'ffi', '~> 1.0.0'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.add_development_dependency 'shoulda-context', '~> 1.0'

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc",
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "lib/nis-ffi.rb",
    "lib/nis-ffi/version.rb",
    "nis-ffi.gemspec",
    "test/helper.rb",
    "test/test_errors.rb",
    "test/test_server.rb",
  ]
end
