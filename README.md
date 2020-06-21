# terraform-aws-storage-file-gateway

[![Release](https://img.shields.io/github/release/masterpointio/terraform-aws-storage-file-gateway.svg)](https://github.com/masterpointio/terraform-aws-storage-file-gateway/releases/latest)

A Terraform module to create an AWS Storage Gateway File Gateway

## Usage

TODO

```hcl
provider "aws" {
  region = "us-east-1"
}

module "storage_file_gateway" {
  source = "git::https://github.com/masterpointio/terraform-aws-storage-file-gateway.git?ref=tags/0.1.0"

  namespace                    = var.namespace
  stage                        = var.stage
  name                         = "mattgowie"
}
```

## Credits

1. [cloudposse/terraform-null-label](https://github.com/cloudposse/terraform-null-label)

## Roadmap

- [ ] Support multiple buckets / file shares through the same root gateway.
- [ ] Support SMB (if anyone shows interest, reach out).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | The AMI to use for the SSM Agent EC2 Instance. If not provided, the latest 'aws-storage-gateway-\*' AMI will be used. Note: This will update periodically as AWS releases updates to their AMI. Pin to a specific AMI if you would like to avoid these updates. | `string` | `""` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| bucket\_arn | The ARN of the Bucket that we're connecting to the Storage Gateway NFS File Share. | `string` | n/a | yes |
| client\_list | The list of Clients who can connect to the Storage Gateway File Share. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| gateway\_timezone | The Timezone of the File Gateway. | `string` | `"GMT"` | no |
| ingress\_cidr\_blocks | The CIDR blocks to allow ingress into your File Gateway instance. NOTE: Not allowing 0.0.0.0/0 during initial File Gateway creation will cause issues. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| instance\_type | The instance type to use for the Storage Gateway instance. An m5a.xlarge provides the recommended system reqs for a storage gateway host for the best cost point. | `string` | `"m5a.xlarge"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `"storage-gateway"` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | n/a | yes |
| stage | The environment that this infrastructure is being deployed to e.g. dev, stage, or prod | `string` | n/a | yes |
| subnet\_id | The ID of the Subnet which the EC2 Instance will be launched into. | `string` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | `map(string)` | `{}` | no |
| volume\_device\_name | The device\_name for the gateway cache volume. | `string` | `"/dev/xvdb"` | no |
| volume\_size | The size in GB of the gateway cache volume. | `number` | `200` | no |
| volume\_type | The type of EBS volume to use for the gateway cache volume. | `string` | `"gp2"` | no |
| vpc\_id | The VPC ID of the VPC that the Storage Gateway Security Group will be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eip\_public\_ip | The Public IP address of the created Elastic IP. |
| instance\_arn | The ARN of the created EC2 File Gateway instance. |
| instance\_id | The ID of the created EC2 File Gateway instance. |
| nfs\_arn | The ARN of the created NFS File Share. |
| nfs\_id | The ID of the created NFS File Share. |
| nfs\_path | The file share path used by the NFS client to identify the mount point. |
| security\_group\_id | The ID of the created Security Group for the File Gateway's instance. |
| storage\_gateway\_arn | The ARN of the created Storage Gateway File Gateway. |
| storage\_gateway\_id | The ID of the created Storage Gateway File Gateway. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

Contributions are welcome and appreciated!

Found an issue or want to request a feature? [Open an issue](TODO)

Want to fix a bug you found or add some functionality? Fork, clone, commit, push, and PR and we'll check it out.

If you have any issues or are waiting a long time for a PR to get merged then feel free to ping us at [hello@masterpoint.io](mailto:hello@masterpoint.io).

## Built By

[![Masterpoint Logo](https://i.imgur.com/RDLnuQO.png)](https://masterpoint.io)
