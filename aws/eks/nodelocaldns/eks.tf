locals {
  eks = {
    name = "${var.environment}-${var.base_name}-cluster"
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.6.0"

  cluster_name                    = local.eks.name
  cluster_version                 = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets
  map_public_ip_on_launch = false

  create_node_security_group = false

  eks_node_groups_launch_template = {
    system = {
      name                               = "system"
      instance_type                     = "t3.small"
      asg_desired_capacity              = 1
      additional_security_group_ids     = []
      key_name                          = null
      additional_security_group_ids     = []
      kubelet_extra_args                = "--node-labels=eks-nodegroup=system"
      disable_cni                        = false
      disable_scale_down                = false
      taints                            = []
      pre_userdata                      = <<-EOT
        #!/bin/bash
        set -o xtrace
        cat <<-EOF > /etc/profile.d/bootstrap.sh
        export KUBELET_EXTRA_ARGS="--cluster-dns=172.20.0.9"
        EOF
        # Source extra environment variables in bootstrap script
        sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
        sed -i 's/KUBELET_EXTRA_ARGS=$2/KUBELET_EXTRA_ARGS="$2 $KUBELET_EXTRA_ARGS"/' /etc/eks/bootstrap.sh
        EOT
    }
    test = {
      name                               = "test"
      instance_type                     = "t3.small"
      asg_desired_capacity              = 1
      additional_security_group_ids     = []
      key_name                          = null
      additional_security_group_ids     = []
      kubelet_extra_args                = "--node-labels=eks-nodegroup=test,Environment=${var.environment}"
      disable_cni                        = false
      disable_scale_down                = false
      taints                            = []
    }
  }

  depends_on = [module.eks_cluster_security_group]

}

data "aws_eks_cluster_auth" "cluster" {
  name = local.eks.name
}

provider "helm" {
  kubernetes {
    config_context_cluster   = local.eks.name
    config_path              = "~/.kube/config"
    load_config_file         = true
  }
}

resource "helm_release" "node-local-dns" {
  name             = "node-local-dns"
  repository       = "https://charts.deliveryhero.io/"
  chart            = "node-local-dns"
  version          = "0.2.4"
  namespace        = "kube-system"
  set {
    name  = "config.dnsServer"
    value = "172.20.0.10"
  }
  set {
    name  = "config.localDns"
    value = "172.20.0.9"
  }
}