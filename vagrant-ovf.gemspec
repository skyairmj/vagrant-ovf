# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vagrant-ovf/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'vagrant-ovf'
  s.version     = VagrantOVF::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Barry Allard']
  s.email       = ['barry@barryallard.name']
  s.homepage    = 'http://rubygems.org/gems/vagrant-ovf'
  s.summary     = 'A Vagrant plugin to add VMware support.'
  s.description = 'Adds VMware Fusion 3, 4 and Workstation 6, 7 support to Vagrant.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'vagrant-ovf'

  s.add_dependency 'vagrant', '~> 0.9.7'
  s.add_development_dependency 'bacon', '~> 1.1'
  s.add_development_dependency 'shoulda', '~> 2.11'
  s.add_development_dependency 'bundler', '>= 1.0.0'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
