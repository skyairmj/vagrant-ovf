require 'ovf_document'
require 'openssl'

module VagrantOva
  class Command < Vagrant::Command::Base
    register "ova", "Archive a Vagrant box in an OVF compatible format"
    argument :vagrant_box, :type => :string, :required => true, :desc => "The vagrant box to archive as OVA"
    class_option :vmx, :type => :string, :required => false, :default => nil

    # Executes the given rake command on the VMs that are represented
    # by this environment.
    def execute
      existing = @env.boxes.find(options[:vagrant_box])
      box_ovf = @env.boxes_path.join(options[:vagrant_box]).join('box.ovf')
      vagrant_file = @env.boxes_path.join(options[:vagrant_box]).join('Vagrantfile')
      doc = OVFDocument.parse(box_ovf)
      doc.add_file(:href => 'Vagrantfile')
      doc.add_vmware_support unless options[:vmx].nil?
      doc.write_to box_ovf

      # modify SHA1 values of box.ovf & Vagrantfile
      box_ovf_sha1 = OpenSSL::Digest::SHA1.hexdigest(File.read(box_ovf))
      vagrant_file_sha1 = OpenSSL::Digest::SHA1.hexdigest(File.read(vagrant_file))

    end
  end
end
