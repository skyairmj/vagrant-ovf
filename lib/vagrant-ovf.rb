require 'vagrant'
require 'vagrant-ovf/config'
require 'vagrant-ovf/command'
require 'vagrant-ovf/middleware'

# Create a new middleware stack "vmware" which is executed for
# vmware commands. See the VagrantRake::Middleware docs for more
# information.
ova = Vagrant::Action::Builder.new do
  use VagrantOva::Middleware
end

Vagrant::Action.register(:rake, ova)

# Add our custom translations to the load path
# I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)

