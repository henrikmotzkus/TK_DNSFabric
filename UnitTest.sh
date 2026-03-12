az login
terraform init
terraform plan --var-file=terraform.tfvars.example
terraform apply --var-file=terraform.tfvars.example

az network private-dns record-set a list `
    --resource-group Lab_HubNetwork `
    --zone-name privatelink.blob.core.windows.net `
    --query "[?name=='app02']"


az network private-dns record-set a list `
    --resource-group Lab_HubNetwork `
    --zone-name privatelink.blob.core.windows.net `
    --query "[?name=='app01']"
