# Deploying an EKS Cluster with NodeLocal DNSCache

This example shows how to deploy an Amazon Elastic Kubernetes Service (EKS) cluster with NodeLocal DNSCache enabled using Terraform.

## Prerequisites

- AWS CLI
- kubectl
- eksctl
- Terraform
- An AWS account with permissions to create an EKS cluster, VPC, and IAM roles. (An administrator account is recommended.)

## Setup

1. Clone this repository to your local machine.

```
git clone https://github.com/deliveryhero/helm-charts/tree/master/stable/node-local-dns
cd aws/eks/nodelocaldns
```

2. Create an Amazon EKS cluster by running the following command in your terminal:

```
terraform init
terraform apply
```


3. Wait for the EKS cluster to be created. This can take several minutes.

4. Once the EKS cluster is created, run the following command to configure `kubectl` to connect to the cluster:

```
aws eks update-kubeconfig --name <cluster_name>
```

Replace `<cluster_name>` with the name of your EKS cluster.

5. Deploy the `node-local-dns` Helm chart by running the following command:

```
kubectl create ns kube-system
helm install node-local-dns --namespace kube-system https://charts.deliveryhero.io/node-local-dns-0.2.4.tgz --set config.dnsServer=172.20.0.10 --set config.localDns=172.20.0.9
```

This will deploy the `node-local-dns` Helm chart to the `kube-system` namespace with the `config.dnsServer` and `config.localDns` values set to `172.20.0.10` and `172.20.0.9`, respectively.

6. Verify that the `node-local-dns` pod is running by running the following command:

```
kubectl get pods -n kube-system | grep node-local-dns
```

You should see output similar to the following:

```
node-local-dns-<pod_id> 1/1 Running 0 19m
```

If the pod is not running, run the following command to view the pod logs:

```
kubectl logs -n kube-system node-local-dns-<pod_id>
```

Replace `<pod_id>` with the ID of the `node-local-dns` pod.

## Cleanup

To delete the EKS cluster and all associated resources, run the following command:

```
terraform destroy
```

This will delete the EKS cluster, VPC, and all associated resources. Note that this command will also delete any data stored in the EKS cluster, so be sure to back up any important data before running this command.

## References

- [NodeLocal DNSCache](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/)
- [NodeLocal DNSCache Helm Chart](https://github.com/deliveryhero/helm-charts/tree/master/stable/node-local-dns)
- [Amazon EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Helm Documentation](https://helm.sh/docs/)
- [Amazon EKS Workshop](https://www.eksworkshop.com/)