variable "resource_group_name" {
  description = "Resource group containing the existing Private DNS zone."
  type        = string
}

variable "zone_name" {
  description = "Name of the existing Private DNS zone."
  type        = string
  default     = "privatelink.blob.core.windows.net"
}

variable "json_folder" {
  description = "Relative folder path containing DNS record JSON files."
  type        = string
  default     = "dns-records"
}

variable "default_ttl" {
  description = "TTL to use when ttl is not provided per record."
  type        = number
  default     = 300
}

variable "default_tags" {
  description = "Tags to apply when tags are not provided in JSON."
  type        = map(string)
  default     = {}
}
