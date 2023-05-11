output "ip_address" {
  value = vsphere_virtual_machine.vm.guest_ip_addresses[0]
  description = "The IP address of the newly created virtual machine."
}
