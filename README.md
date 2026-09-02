# Kubernetes Homelab

Terraform configuration that provisions resources into the [Kubernetes](https://kubernetes.io/) cluster bootstrapped by [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).

## Tech Stack

- [Envoy Proxy](https://www.envoyproxy.io/) L4/L7 Proxy
- [Envoy Gateway](https://gateway.envoyproxy.io/) Kubernetes Gateway API Implementation
- [MetalLB](https://metallb.io/) Bare-metal load balancer
- [Miniflux](https://miniflux.app/) A minimalists & opinionated feed reader

## Usage

### Pre-Requisites

- [Terraform](https://developer.hashicorp.com/terraform) Installed
- A [Kubernetes](https://kubernetes.io/) cluster. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).
- A [PostgreSQL](https://www.postgresql.org/) database. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox) & [homelab-terraform-postgres](https://github.com/ChrisPJohnstone/homelab-terraform-postgres).

### Get kubeconfig

- Pull the kubeconfig from your control plane
  ```sh
  ssh {username}@{host}:'sudo cat {path_to_config}' > .kubeconfig
  ```
  Example
  ```sh
  ssh chris@192.168.0.150 'sudo cat /etc/kubernetes/admin.conf' > .kubeconfig
  ```

### Setting Variables

- Copy [`terraform/.auto.tfvars.dist`](./terraform/.auto.tfvars.dist) to `terraform/.auto.tfvars`
  ```sh
  cp terraform/.auto.tfvars.dist terraform/.auto.tfvars
  ```
- Update the values in `terraform/.auto.tfvars`

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
