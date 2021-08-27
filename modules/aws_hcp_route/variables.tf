variable "hvn_id" {
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "The AWS ID of the VPC which to peer"
}

variable "route_table_ids" {
  type        = list(string)
  description = "A list of route table IDs which to add the HVN CIDR"
}
