/*
 *
 * Required Variables
 *
 */

variable "cluster_id" {
  type        = string
  description = "The name of your HCP Consul cluster"
}

/*
 *
 * Optional Variables
 *
 */

variable "region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

# variable "vpc_cidr_block" {
#   type        = string
#   description = "The CIDR block to create the VPC in"
#   default     = "172.25.16.0/20"
# }

variable "hvn_id" {
  type        = string
  description = "The name of your HCP HVN"
  default     = "hvn-terraform"
}

variable "hvn_cidr_block" {
  type        = string
  description = "The CIDR range to create the HCP HVN with"
  default     = "172.25.32.0/20"
}

variable "enable_public_url" {
  type        = bool
  description = "A boolean that determines whether the Consul cluster has a public URL"
  default     = false
}

variable "size" {
  type        = string
  description = "The HCP Consul size to use when creating a Consul cluster"
  default     = null
}

variable "tier" {
  type        = string
  description = "The HCP Consul tier to use when creating a Consul cluster"
  default     = "development"
}