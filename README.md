# Kubernetes Homelab

Terraform configuration that provisions resources into the [Kubernetes](https://kubernetes.io/) cluster bootstrapped by [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).

## Tech Stack

#### Networking

- [Cloudflare Tunnel](https://developers.cloudflare.com/tunnel/) Zero trust network tunnel to access your infrastructure publically
- [Envoy Proxy](https://www.envoyproxy.io/) L4/L7 Proxy
- [Envoy Gateway](https://gateway.envoyproxy.io/) Kubernetes Gateway API Implementation
- [MetalLB](https://metallb.io/) Bare-metal load balancer

#### Services

- [Miniflux](https://miniflux.app/) A minimalists & opinionated feed reader

## Usage

### Pre-Requisites

- A [Kubernetes](https://kubernetes.io/) cluster. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).
- A [PostgreSQL](https://www.postgresql.org/) database. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox) & [homelab-terraform-postgres](https://github.com/ChrisPJohnstone/homelab-terraform-postgres).
- A [Cloudflare](https://www.cloudflare.com/) account & your own domain
- [Terraform](https://developer.hashicorp.com/terraform) Installed

### Get kubeconfig

- Pull the kubeconfig from your control plane
    ```sh
    ssh {username}@{host}:'sudo cat {path_to_config}' > .kubeconfig
    ```
    Example
    ```sh
    ssh chris@192.168.0.150 'sudo cat /etc/kubernetes/admin.conf' > .kubeconfig
    ```

### Cloudflare setup

- TODO: Script this, in the meantime doc links clicky buttons
    - API token requires these permissions
        - Account - Cloudflare Tunnel - Edit
        - Zone - DNS - Edit
    - [Create API Token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
    - [Get Account & Zone ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/)

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
