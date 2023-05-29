terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.66.0"
    }
  }
}

provider "google" {
  region      = var.region
  zone        = var.zone
  project     = var.project
  credentials = var.credentials_file_path
}

# Create a VPC because GCP's default does not include IPv6. in 2023.
resource "google_compute_network" "test_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "test_external_subnet" {
  name                       = var.subnet_name
  region                     = var.region
  network                    = google_compute_network.test_vpc.self_link
  ip_cidr_range              = "10.2.0.0/24"
  stack_type                 = "IPV4_IPV6"
  ipv6_access_type           = "EXTERNAL"
  private_ip_google_access   = true
  private_ipv6_google_access = "ENABLE_BIDIRECTIONAL_ACCESS"
}

resource "google_compute_firewall" "test_firewall_ipv4" {
  name    = var.firewall_name_ipv4
  network = google_compute_network.test_vpc.name

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
}

resource "google_compute_firewall" "test_firewall_ipv6" {
  name    = var.firewall_name_ipv6
  network = google_compute_network.test_vpc.name

  direction     = "INGRESS"
  source_ranges = ["::/0"]

  allow {
    protocol = "58"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
}


# ===================================================================
# STOP!
# 1. Run `terraform apply` to create the VPC above
# 2. Then, manually create the static IP addresses because v4.66.0
# of the GCP provider does not support creating static IPv6 yet
# 3. Uncomment the section below
# 4. Run `terraform apply` again
# ===================================================================


# data "google_compute_address" "reserved_ipv4_address" {
#   name = var.reserved_ipv4_address_name
# }
# data "google_compute_address" "reserved_ipv6_address" {
#   name = var.reserved_ipv6_address_name
# }

# output "ip_region" {
#   value = data.google_compute_address.reserved_ipv6_address.region
# }

# data "google_service_account" "terraform_sa" {
#   account_id = var.service_account_name
# }

# resource "google_compute_instance" "default" {
#   name         = "test"
#   machine_type = "e2-micro"
#   zone         = var.zone

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     stack_type = "IPV4_IPV6"
#     network    = google_compute_network.test_vpc.self_link
#     subnetwork = google_compute_subnetwork.test_external_subnet.self_link

#     access_config {
#       nat_ip       = data.google_compute_address.reserved_ipv4_address.address
#       network_tier = "PREMIUM"
#     }

#     access_config {
#       nat_ip       = data.google_compute_address.reserved_ipv6_address.address
#       network_tier = "PREMIUM"
#     }

#     ipv6_access_config {
#       network_tier = "PREMIUM"
#     }
#   }

#   service_account {
#     email  = data.google_service_account.terraform_sa.email
#     scopes = ["https://www.googleapis.com/auth/cloud-platform"]
#   }
# }
