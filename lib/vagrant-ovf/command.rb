require 'optparse'
require File.dirname(__FILE__)+'/ovf_document'
require 'openssl'

module VagrantOVF
  class Command < Vagrant::Command::Base
    # Executes the given rake command on the VMs that are represented
    # by this environment.
    def execute
      options = {}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: vagrant ovf [vm-name]"
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv
      existing = @env.boxes.find(argv[0])
      if existing.nil?
        raise RuntimeError, "No box found with name #{options[:vagrant_box]}"
      end
      box_path = @env.boxes_path.join(argv[0])
      box_ovf = box_path.join('box.ovf')
      vagrant_file = box_path.join('Vagrantfile')
      box_mf = box_path.join('box.mf')
      box_disk1 = box_path.join('box-disk1.vmdk')
      doc = OVFDocument.parse(File.new(box_ovf), &:noblanks)
      doc.add_file(:href => 'Vagrantfile')
      doc.add_vmware_support
      File.open(box_ovf, 'w') {|f| doc.write_xml_to f}

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
