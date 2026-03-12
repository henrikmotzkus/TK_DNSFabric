output "record_names" {
  description = "Record set names created from JSON files."
  value       = keys(azurerm_private_dns_a_record.this)
}

output "record_count" {
  description = "Number of A record sets managed."
  value       = length(azurerm_private_dns_a_record.this)
}
