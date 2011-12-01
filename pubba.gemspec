# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/lib/sinatra/pubba/version'
require 'date'

Gem::Specification.new do |s|
  s.name              = 'pubba'
  s.version           = Pubba::VERSION
  s.date              = Date.today.to_s
  s.authors           = ['Andrew Stone']
  s.email             = ['andy@stonean.com']
  s.summary           = 'Pubba is a Sinatra extension.'
  s.description       = 'Pubba is a Sinatra extension designed to help you manage your site.'
  s.homepage          = 'http://github.com/stonean/pubba'
  s.extra_rdoc_files  = %w(README.md)
  s.rdoc_options      = %w(--charset=UTF-8)
  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)


  s.add_runtime_dependency('sprockets', ['~> 2.1.2'])
  s.add_runtime_dependency('r18n-desktop', ['~> 0.4.11'])

  s.add_development_dependency('rake', ['>= 0.9.2'])
  s.add_development_dependency('sinatra', ['>= 1.3.1'])
  s.add_development_dependency('sinatra-contrib', ['>= 1.3.1'])
  s.add_development_dependency('yard', ['>= 0'])
end