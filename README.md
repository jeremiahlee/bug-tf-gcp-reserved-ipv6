This work is marked with CC0 1.0 Universal. It is dedicated to the public domain.

This repository demonstrates a bug: the inability for a reserved IPv6 address to be assigned to a compute instance.

Please vote for this issue: https://github.com/hashicorp/terraform-provider-google/issues/13916

My comment referencing this bug/missing feature: https://github.com/hashicorp/terraform-provider-google/issues/13916#issuecomment-1566985485


# How to run

1. Add your project and service account credentials to terraform.tfvars

2. Run `terraform init` and `terraform apply`

3. Create the static external IPv4 and IPv6 addresses manually because the provider does not yet support creating static external IPv6 addresses for VMs.

Reserve IPv4 address:
`gcloud compute addresses create test-static-address-ipv4-1 --region=europe-north1 --project=YOUR-PROJECT-HERE`

Reserve IPv6 address:
`gcloud compute addresses create test-static-address-ipv6-1 --ip-version=IPV6 --region=europe-north1 --endpoint-type=VM --subnetwork=projects/YOUR-PROJECT-HERE/regions/europe-north1/subnetworks/test-external-subnet-1 --project=YOUR-PROJECT-HERE`

4. Uncomment the bottom portion of main.tf and run `terraform apply` again.

5. Enjoy the error:

> Error: Error creating instance: googleapi: Error 400: Invalid value for field 'resource.networkInterfaces[0].accessConfigs[1].natIP': '2600:1900:4150:ba95::'. The specified external IP address '2600:1900:4150:ba95::' was not found in region 'europe-north1'., invalid

Even though
```
Outputs:
ip_region = "europe-north1"
```
is reported for the reserved external IPv6 address.


## How to create a service account

Go to https://console.cloud.google.com/iam-admin/serviceaccounts/create

1. Name: terraform-sa
2. Role: Quick Access: Basic > Editor
3. Done
4. Tap the Actions icon in the list, Manage Keys
5. Add Key > Create New Key
6. Type: JSON, Create
7. Add to this directory and update terraform.tfvars with the filename
