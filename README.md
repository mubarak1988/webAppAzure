# webAppAzure
1.Create Resource Group using 
az group create -l <location> -n <ResourceGroupName>


2. Create SP using 
 az ad sp create-for-rbac --name <sp name> --sdk-auth --role contributor --scopes /subscriptions/<subscription_id>/resourceGroups/<ResourceGroupName>

3. Add the generated clientId, clientSecret and tenantId to the repo secret 
   