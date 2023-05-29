variable "credentials_file_path" {
  description = "Path to the JSON file of the service account credentials"
  sensitive   = true
}

variable "project" {}

variable "service_account_name" {}

variable "region" {
  default = "europe-north1"
}

variable "zone" {
  default = "europe-north1-a"
}

# VPC network
variable "vpc_name" {
  default = "test-vpc-1"
}
variable "subnet_name" {
  default = "test-external-subnet-1"
}
variable "firewall_name_ipv4" {
  default = "test-firewall-ipv4-1"
}
variable "firewall_name_ipv6" {
  default = "test-firewall-ipv6-1"
}

variable "reserved_ipv4_address_name" {
  default = "test-static-address-ipv4-1"
}
variable "reserved_ipv6_address_name" {
  default = "test-static-address-ipv6-1"
}

