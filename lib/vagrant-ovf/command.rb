require 'ovf_document'
require 'openssl'

module VagrantOVF
  class Command < Vagrant::Command::Base
    register "ovf", "Convert the Vagrant box in an OVF compatible format"
    argument :vagrant_box, :type => :string, :required => true, :desc => "The vagrant box to be converted as ovf"
    class_option :vmx, :type => :string, :required => false, :default => nil

    # Executes the given rake command on the VMs that are represented
    # by this environment.
    def execute
      existing = @env.boxes.find(options[:vagrant_box])
      if existing.nil?
        raise RuntimeError, "No box found with name #{options[:vagrant_box]}"
      end
      box_path = @env.boxes_path.join(options[:vagrant_box])
      box_ovf = box_path.join('box.ovf')
      vagrant_file = box_path.join('Vagrantfile')
      box_mf = box_path.join('box.mf')
      box_disk1 = box_path.join('box-disk1.vmdk')
      doc = OVFDocument.parse(File.new(box_ovf), &:noblanks)
      doc.add_file(:href => 'Vagrantfile')
      doc.add_vmware_support unless options[:vmx].nil?
      doc.write_to(File.new(box_ovf), :encoding => 'UTF-8', :indent => 4)

      # rewrite SHA1 values of box.ovf & Vagrantfile
      box_ovf_sha1 = OpenSSL::Digest::SHA1.hexdigest(File.read(box_ovf))
      vagrant_file_sha1 = OpenSSL::Digest::SHA1.hexdigest(File.read(vagrant_file))
      box_disk1_sha1 = OpenSSL::Digest::SHA1.hexdigest(File.read(box_disk1))
      File.open(box_mf, 'w') do |f|
        f.write("SHA1 (box.ovf)= #{box_ovf_sha1}\n")
        f.write("SHA1 (box-disk1.vmdk)= #{box_disk1_sha1}\n")
        f.write("SHA1 (Vagrantfile)= #{vagrant_file_sha1}")
      end
    end
  end
end
