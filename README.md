# Kubernetes Homelab

Terraform configuration that provisions resources into the [Kubernetes](https://kubernetes.io/) cluster bootstrapped by [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).

## Tech Stack

- [Envoy Proxy](https://www.envoyproxy.io/) L4/L7 Proxy
- [Envoy Gateway](https://gateway.envoyproxy.io/) Kubernetes Gateway API Implementation
- [MetalLB](https://metallb.io/) Bare-metal load balancer

## Usage

### Pre-Requisites

- [Terraform](https://developer.hashicorp.com/terraform) Installed
- A kubernetes cluster. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).

### Get kubeconfig

- Pull the kubeconfig from your control plane
  ```sh
  ssh {username}@{host}:'sudo cat {path_to_config}' > .kubeconfig
  ```
  Example
  ```sh
  ssh chris@192.168.0.150 'sudo cat /etc/kubernetes/admin.conf' > .kubeconfig
  ```

### Managing Resources

> [!NOTE]
> All commands should be run from [terraform](./terraform/) directory

- Deploy Resources
  ```sh
  ./deploy
  ```
- Destroy Resources
  ```sh
  terraform destroy
  ```
