Terraform tried:


```json
"networkInterfaces": [
  {
  "accessConfigs": [
    {
    "natIP": "34.88.182.23",
    "networkTier": "PREMIUM",
    "type": "ONE_TO_ONE_NAT"
    },
    {
    "natIP": "2600:1900:4150:ba95::",
    "networkTier": "PREMIUM",
    "type": "ONE_TO_ONE_NAT"
    }
  ],
  "ipv6AccessConfigs": [
    {
    "networkTier": "PREMIUM",
    "type": "DIRECT_IPV6"
    }
  ],
  "network": "projects/norse-decoder-385514/global/networks/test-vpc-1",
  "stackType": "IPV4_IPV6",
  "subnetwork": "projects/norse-decoder-385514/regions/europe-north1/subnetworks/test-external-subnet-1"
  }
]
```

Google Console would have done:


```json
"networkInterfaces": [
  {
    "accessConfigs": [
      {
        "name": "External NAT",
        "natIP": "34.88.182.23",
        "networkTier": "PREMIUM"
      }
    ],
    "ipv6AccessConfigs": [
      {
        "externalIpv6": "2600:1900:4150:ba95::",
        "externalIpv6PrefixLength": 96,
        "name": "external-ipv6",
        "networkTier": "PREMIUM",
        "type": "DIRECT_IPV6"
      }
    ],
    "stackType": "IPV4_IPV6",
    "subnetwork": "projects/norse-decoder-385514/regions/europe-north1/subnetworks/test-external-subnet-1"
  }
]
```
