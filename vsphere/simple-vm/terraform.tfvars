# vSphere Specific
vsphere_user = "<your_vsphere_user>"
# Enter your vSphere password below, or use environment variables to avoid storing passwords in plain text
# vsphere_password = "<your_vsphere_password>"
vsphere_vcenter = "<your_vcenter_ip>"

# Virtual Machine Configuration
cpu                = 4
cores_per_socket   = 2
ram                = 4096
disksize           = 100 # in GB
vm_guest_id        = "ubuntu64Guest"
vsphere_unverified_ssl = "true"
vsphere_datacenter = "Datacenter"
vsphere_cluster    = "Cluster01"
vm_datastore       = "Datastore1_SSD"
vm_network         = "VM Network"
vm_domain          = "home"
dns_server_list    = ["192.168.1.80", "8.8.8.8"]
name               = "ubuntu22-04-test"
ipv4_address       = "192.168.1.97"
ipv4_gateway       = "192.168.1.254"
ipv4_netmask       = "24"
vm_template_name   = "Ubuntu-2204-Template-100GB-Thin"
