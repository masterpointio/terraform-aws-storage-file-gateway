# complete.tf
variable "stage" {
  default     = "test"
  type        = string
  description = "The environment that this infrastrcuture is being deployed to e.g. dev, stage, or prod"
}

variable "namespace" {
  default     = "mp"
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "region" {
  default     = "us-west-2"
  type        = string
  description = "The AWS Region to deploy these resources to."
}

variable "availability_zones" {
  default     = ["us-west-2a"]
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}
