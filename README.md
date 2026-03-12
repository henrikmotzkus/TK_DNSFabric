# Azure Private DNS from JSON (Terraform)

This configuration reads JSON files from `dns-records/` and creates A records in an existing Azure Private DNS zone.

## Prereqs
- Terraform >= 1.5
- `az login` (or managed identity) with permission to read and write the target Private DNS zone
- Existing Private DNS zone `privatelink.blob.core.windows.net` in a known resource group

## How it works
- Each `*.json` file in `dns-records/` describes one A record set.
- Terraform `fileset` + `jsondecode` load all files; a `for_each` block creates A records.
- Removing a JSON file causes Terraform to remove the corresponding DNS record set on next apply.

## JSON schema (one file per record set)
```json
{
  "name": "app01",
  "ttl": 300,                 // optional, defaults to 300
  "records": ["10.1.2.3"],   // IPv4 addresses
  "tags": {                   // optional
    "owner": "team-x"
  }
}
```

## Usage
1. Set the resource group name and (optionally) override defaults:
   - `resource_group_name` (required)
   - `zone_name` (defaults to privatelink.blob.core.windows.net)
   - `json_folder` (defaults to dns-records)
2. Add or remove JSON files under `dns-records/`.
3. Run:
   ```sh
   terraform init
   terraform plan -var="resource_group_name=<rg>"
   terraform apply -var="resource_group_name=<rg>"
   ```

## Notes
- Only A records are managed in this version.
- IPv4 validation is enforced; empty records arrays are rejected.
- State is local; switch to a remote backend when ready.

## Warning

This was completely vide coded!