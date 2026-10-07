# Kubernetes Homelab

Terraform configuration that provisions resources into the [Kubernetes](https://kubernetes.io/) cluster bootstrapped by [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).

## Tech Stack

#### Networking

- [Cloudflare Tunnel](https://developers.cloudflare.com/tunnel/) Zero trust network tunnel to access your infrastructure publically
- [Envoy Proxy](https://www.envoyproxy.io/) L4/L7 Proxy
- [Envoy Gateway](https://gateway.envoyproxy.io/) Kubernetes Gateway API Implementation
- [MetalLB](https://metallb.io/) Bare-metal load balancer

#### Storage

- [Longhorn](https://longhorn.io/) Distributed block storage, installed as the default StorageClass

#### Services

- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) A self hosted password manager
    - Admin panel & registration are disabled by default for security reasons however you will need to enable the admin temporarily to create your first user.
        - Toggle the [`vaultwarden_admin_token_version`](./terraform/variables.tf) envar in your [variables](#setting-variables) to `true` & [Deploy](#Managing-Resources)
        - [Get your admin password from kubernetes secrets](./scripts/get_vaultwarden_admin_token)
        - Navigate to `https://domain/admin` e.g. `https://vaultwarden.home.lab/admin`
        - Follow the UI to invite any users you want
        - Toggle the [`vaultwarden_admin_token_version`](./terraform/variables.tf) envar in your [variables](#setting-variables) to `false` & [Deploy](#Managing-Resources)
- [Miniflux](https://miniflux.app/) A minimalists & opinionated feed reader

## Usage

### Pre-Requisites

- A [Kubernetes](https://kubernetes.io/) cluster. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox).
    - `open-iscsi` & `nfs-common` installed on each node that will host replicas, with `iscsid` running
- A [PostgreSQL](https://www.postgresql.org/) database. For more details on how mine is hosted & provisioned see [homelab-terraform-proxmox](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox) & [homelab-terraform-postgres](https://github.com/ChrisPJohnstone/homelab-terraform-postgres).
- A [Cloudflare](https://www.cloudflare.com/) account & your own domain
- An SMTP server set up - [GMail Example](https://www.geeksforgeeks.org/techtips/how-to-use-the-gmail-smtp-server-to-send-emails-for-free/)
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

### Cloudflare API Token

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

- [Deploy Resources](./deploy)
- [Destroy Resources](./destroy)
