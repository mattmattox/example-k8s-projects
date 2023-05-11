# Terraform vSphere Virtual Machine Creation

This Terraform script creates a new virtual machine in vSphere based on an existing template. The new virtual machine is configured with a specified number of CPUs, amount of RAM, and disk size, and is customized with cloud-init metadata that sets up network settings, SSH access, and package installations.

## Prerequisites

Before you can use this script, you must have the following:

- A vSphere environment with an existing template to use as the basis for the new virtual machine.
- A vSphere user account with appropriate permissions to create a new virtual machine.
- A Terraform installation (version 0.14 or higher) with the vSphere provider plugin installed.

## Usage

1. Clone this repository to your local machine.
2. Create a `terraform.tfvars` file in the cloned repository directory and populate it with the necessary variables. See `vars.auto.tfvars` for an example.
3. Create a `userdata.yaml` file in the `templates` directory and customize it as needed to set up network settings, SSH access, and package installations on the new virtual machine.
4. Run `terraform init` to initialize the Terraform environment.
5. Run `terraform plan` to preview the changes that will be made to the vSphere environment.
6. If the plan looks correct, run `terraform apply` to create the new virtual machine.

## Output

After running `terraform apply`, the script will output the IP address of the newly created virtual machine.

## Clean up

To remove the virtual machine created by this script, run `terraform destroy`

This will delete the virtual machine and all associated resources.

Note: This script creates resources that may incur costs on your vSphere environment. Be sure to review your vSphere pricing and usage policies before running this script.

For more information about using Terraform with vSphere, see the [vSphere Provider documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs).
