data "azurerm_private_dns_zone" "this" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

locals {
  ipv4_pattern = "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$"

  record_files = fileset(var.json_folder, "*.json")

  record_json = {
    for file_name in local.record_files :
    file_name => jsondecode(file("${var.json_folder}/${file_name}"))
  }

  records = {
    for file_name, rec in local.record_json :
    rec.name => {
      name        = rec.name
      ttl         = try(rec.ttl, var.default_ttl)
      records     = rec.records
      tags        = try(rec.tags, var.default_tags)
      source_file = file_name
    }
    if can(rec.name) && can(rec.records)
  }
}

resource "azurerm_private_dns_a_record" "this" {
  for_each = local.records

  name                = each.value.name
  zone_name           = data.azurerm_private_dns_zone.this.name
  resource_group_name = data.azurerm_private_dns_zone.this.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags

  lifecycle {

    precondition {
      condition     = length(each.value.records) > 0
      error_message = "records must not be empty in ${each.value.source_file}"
    }

    precondition {
      condition     = alltrue([for ip in each.value.records : can(regex(local.ipv4_pattern, ip))])
      error_message = "records must contain only IPv4 addresses in ${each.value.source_file}"
    }
  }
}
