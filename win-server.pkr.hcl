// vSphere plugin
packer {
  required_plugins {
    vsphere = {
      version = "~> 1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}
// Details for the template
source "vsphere-iso" "windows_2022" {
  vcenter_server      = var.vcenterServer
  username            = var.vcenterUser
  password            = var.vcenterPass
  cluster             = var.vcenterCluster
  datacenter          = var.vcenterDatacenter
  folder              = var.templateFolder
  datastore           = var.vcenterDatastore
  host                = var.vcenterHost
  insecure_connection = "true"

  vm_name              = var.templateName
  winrm_password       = var.winrmPassword
  winrm_username       = var.winrmUser
  CPUs                 = "4"
  RAM                  = "8192"
  RAM_reserve_all      = true
  communicator         = "winrm" 
  disk_controller_type = ["lsilogic-sas"]
  firmware             = "efi-secure"

  //files packer uses to customize the template
  floppy_files         = ["setup/w2k22/autounattend.xml", "setup/winrm.ps1", "setup/vmwaretools.cmd"]
  guest_os_type        = "windows9Server64Guest"
  
  // storage location containing the ISOs for Server 2022 and vmware tools (windows.iso)
  iso_paths            = ["[datastore1] ISO/SERVER_EVAL_x64FRE_en-us.iso", "[datastore1] ISO/windows.iso"]
  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }
// Hard disk information
  storage {
    disk_size             = "61440"
    disk_thin_provisioned = true
  }

  convert_to_template = "true"
}

build {
  sources = ["source.vsphere-iso.windows_2022"]

  provisioner "windows-shell" {
    inline = ["dir c:\\"]
  }
}