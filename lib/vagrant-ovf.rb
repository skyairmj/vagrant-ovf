require 'vagrant'
require 'vagrant-ovf/config'
require 'vagrant-ovf/command'
require 'vagrant-ovf/middleware'

# Create a new middleware stack "ovf" which is executed for
# ovf commands. See the VagrantRake::Middleware docs for more
# information.
ovf = Vagrant::Action::Builder.new do
  use VagrantOVF::Middleware
end

Vagrant::Action.register(:rake, ovf)

# Add our custom translations to the load path
# I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)

