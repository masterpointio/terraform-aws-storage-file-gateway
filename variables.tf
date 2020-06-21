# variables.tf

# storage_gateway.tf

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "The environment that this infrastructure is being deployed to e.g. dev, stage, or prod"
}

variable "name" {
  default     = "storage-gateway"
  type        = string
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

##########
## EC2 ##
########

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet which the EC2 Instance will be launched into."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID of the VPC that the Storage Gateway Security Group will be created in."
}

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "The CIDR blocks to allow ingress into your File Gateway instance. NOTE: Not allowing 0.0.0.0/0 during initial File Gateway creation will cause issues."
}

variable "instance_type" {
  default     = "m5a.xlarge"
  type        = string
  description = "The instance type to use for the Storage Gateway instance. An m5a.xlarge provides the recommended system reqs for a storage gateway host for the best cost point."
}

variable "ami" {
  default     = ""
  type        = string
  description = "The AMI to use for the SSM Agent EC2 Instance. If not provided, the latest 'aws-storage-gateway-*' AMI will be used. Note: This will update periodically as AWS releases updates to their AMI. Pin to a specific AMI if you would like to avoid these updates."
}

variable "volume_device_name" {
  default     = "/dev/xvdb"
  type        = string
  description = "The device_name for the gateway cache volume."
}

variable "volume_size" {
  default     = 200
  type        = number
  description = "The size in GB of the gateway cache volume."
}

variable "volume_type" {
  default     = "gp2"
  type        = string
  description = "The type of EBS volume to use for the gateway cache volume."
}

######################
## STORAGE GATEWAY ##
####################

variable "gateway_timezone" {
  default     = "GMT"
  type        = string
  description = "The Timezone of the File Gateway."
}

variable "bucket_arn" {
  type        = string
  description = "The ARN of the Bucket that we're connecting to the Storage Gateway NFS File Share."
}

variable "client_list" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "The list of Clients who can connect to the Storage Gateway File Share."
}
