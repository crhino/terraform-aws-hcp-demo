variable "hvn" {
  type = object({
    hvn_id     = string
    self_link  = string
    cidr_block = string
  })
}

variable "vpc_id" {
  type        = string
  description = "The AWS ID of the VPC which to peer"
}

variable "owner_id" {
  type        = string
  description = "The AWS owner ID of the VPC which to peer"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region of the HCP peering connection."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the peered VPC."
}

variable "route_table_ids" {
  type        = list(string)
  description = "A list of route table IDs which to add the HVN CIDR"
}

variable "number_of_route_table_ids" {
  type        = number
  description = "Number of routing table ids. Works around GH-4149."
}
