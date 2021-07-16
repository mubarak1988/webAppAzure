$gitrepo = "https://github.com/mubarak1988/webAppAzure.git"
#$gittoken = "$Env:GIT_TOKEN"
$webappname = "webApp"
#$location = "westeurope"
# VM configuration object
$ResourceGroupName = "geekResourceGroup"
$VmName = "vm-from-gh"

# Login to Azure using Service Principal credentials from Github Secrets
Write-Output "Logging in to Azure with a service principal..."
az login `
    --service-principal `
    --username $Env:SP_CLIENT_ID `
    --password $Env:SP_CLIENT_SECRET `
    --tenant $Env:SP_TENANT_ID

Write-Output "az login complete"

# Select Azure subscription
az account set `
    --subscription $Env:AZURE_SUBSCRIPTION_NAME



# Create a VM in Azure
Write-Output "Creating VM..."
try {
    az vm create  `
        --resource-group $ResourceGroupName `
        --name $VmName `
        --image win2016datacenter `
        --admin-password $Env:SP_CLIENT_SECRET `
    
}
catch {
    Write-Output "VM already exists"
}
Write-Output "Done creating VM"

# Create an App Service plan in Free tier.
az appservice plan create -g $ResourceGroupName -n $webappname --sku F1 

# Create a web app.
az webapp create -g $ResourceGroupName -p $webappname -n $webappname --runtime "DOTNET|5.0"

az webapp deployment source config --branch master --repo-url $gitrepo --app-working-dir dotnetcorewebapp --name $webappname --resource-group $ResourceGroupName

Write-Output "Completed"

