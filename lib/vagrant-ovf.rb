require 'vagrant'
require 'vagrant-ovf/command'

Vagrant.commands.register(:ovf){ VagrantOVF::Command}
# Add our custom translations to the load path
# I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)

