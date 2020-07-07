# AKS Getting Started Guide Configuration

# Prerequisites

Before starting the deployment, there are several required steps:

- Install the required common tools (kubectl, Azure CLI, and terraform).  Note: this tutorial currently uses [Terraform 0.12.6](https://releases.hashicorp.com/terraform/0.12.6/).
- Enroll as an Azure subscriber.
- Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).


## Create Azure Resource Group

Note: You need to create a resource group in your subscription first before you apply terraform. Use the following command to create a resource group

```bash
az group create -l eastus -n pkdemorg

{
  "id": "/subscriptions/dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d/resourceGroups/aksdemorg",
  "location": "eastus",
  "managedBy": null,
  "name": "aksdemorg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

## Create an Azure Service Principal

We use a single [Azure Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals) for configuring Terraform and for the [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/services/kubernetes-service/) cluster being deployed. In Bedrock, see the [Service Principal documention](https://github.com/microsoft/bedrock/tree/master/cluster/azure#create-an-azure-service-principal).

[Login to the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) using the `az login` command.

Get the Id of the subscription by running `az account show`.

Then, create the Service Principal using `az ad sp create-for-rbac --role contributor --scopes "/subscriptions/dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d"` as follows:

```bash
~$ az account show
{
  "environmentName": "AzureCloud",
  "homeTenantId": "06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7",
  "id": "dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Azure-test-pk",
  "state": "Enabled",
  "tenantId": "06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7",
  "user": {
    "name": "nsasidhara@pkglobal.com",
    "type": "user"
  }
}
~$ az ad sp create-for-rbac --role contributor --scopes "/subscriptions/dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d"
{
  "appId": "18262b84-XXXX-XXXX-XXXX-7f6191dc0607",
  "displayName": "azure-cli-2020-06-23-13-35-18",
  "name": "http://azure-cli-2020-06-23-13-35-18",
  "password": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "tenant": "06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7"
}
```

Take note of the following values. They will be needed for configuring Terraform as well as the deployment as described under the heading [Configure Terraform for Azure Access](#configure-terraform-for-azure-access):

- Subscription Id (id from account): dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d
- Tenant Id: 06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7
- Client Id (appId): 18262b84-XXXX-XXXX-XXXX-7f6191dc0607
- Client Secret (password): XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

## Create an RSA Key Pair to use as Node Key

The Terraform scripts use this node key to setup log-in credentials on the nodes in the AKS cluster. We will use this key when setting up the Terraform deployment variables. To generate the node key, run `ssh-keygen -b 4096 -t rsa -f ~/.ssh/node-ssh-key`:

```bash
$ ssh-keygen -b 4096 -t rsa -f ~/.ssh/node-ssh-key
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/user/.ssh/node-ssh-key.
Your public key has been saved in /home/user/.ssh/node-ssh-key.pub.
The key fingerprint is:
SHA256:+8pQ4MuQcf0oKT6LQkyoN6uswApLZQm1xXc+pp4ewvs jims@fubu
The key's randomart image is:
+---[RSA 4096]----+
|   ...           |
|  . o. o .       |
|.. .. + +        |
|... .= o *       |
|+  ++ + S o      |
|oo=..+ = .       |
|++ ooo=.o        |
|B... oo=..       |
|*+. ..oEo..      |
+----[SHA256]-----+
```

## Configure Terraform For Azure Access

Terraform supports a number of methods for authenticating with Azure. Bedrock uses [authenticating with a Service Principal and client secret](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html). This is done by setting a few environment variables via the Bash `export` command.

To set the variables, use the key created under the previous heading [Create an Azure Service Principal](#create-an-azure-service-principal). (The ARM_CLIENT_ID is `app_id` from the previous procedure. The ARM_SUBSCRIPTION_ID is account `id`.)

Set the variables as follows:

```bash
export ARM_SUBSCRIPTION_ID=dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d
export ARM_TENANT_ID=06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7
export ARM_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export ARM_CLIENT_ID=18262b84-XXXX-XXXX-XXXX-7f6191dc0607
```

If you execute `env | grep ARM` you should see:

```bash
$ env | grep ARM
ARM_SUBSCRIPTION_ID=dbd836b0-XXXX-XXXX-XXXX-dd192ad4e49d
ARM_TENANT_ID=06b63d62-XXXX-XXXX-XXXX-4971ff69c4c7 
ARM_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
ARM_CLIENT_ID=18262b84-XXXX-XXXX-XXXX-7f6191dc0607
```

## To use storage account as backend to store the tfstate file
For using Storage account to store the state file
Create a storage account, and enable the versioning (very vital to enable versioning to save the terraform.tfstate versions)
Create a container in which state file needs to be stored

Get the access key of storage account created
```
Go to storage accounts --> click on storage account name created --> go to settings --> Access keys and copy the key
```
run the following command to store access key as env variable

```bash
export ARM_ACCESS_KEY=13hTpMO2xi585bjul96RGaEDMTnsigAS1Yjrn9mP3A++VomWZpF+OJcMHN8R+TVnkj+NdA+2oYZTIIGt564rIA==

```

During the terraform initialization, only for the first time it will prompt for Storage account, Container name and Key name (Name of the state file to store) for the user to enter. 

#Variables to enter for cluster configuration

Following variables has to be entered by users which are taken as inputs for cluster configuration

```list
client_id --> Please specify client_id (service_principal_id).
client_secret  --> Please specify client_secret (service_principal_secret).
subscription_id --> Subsription_id
tenant_id --> tenant_id
availability_zones --> A list of AZs across which the Node Pool should be spread. Ex: ["1", "2", "3"]
resource_group_name  --> Default resource group name that the network will be created in.
cluster_name  --> The name of the Managed Kubernetes Cluster to create.
ssh_public_key  --> The ssh_public_key is the RSA public key that was created for AKS node access. *ex: ssh-rsa XXXXX... user@example*
address_space  --> The address space that is used by the virtual network. *ex: 10.10.0.0/16*
initial_vm_count  --> Please specify initial number of worker nodes for AKS Cluster.
min_vm_count   --> Please specify minimum number of worker nodes for AKS Cluster.
max_vm_count   --> Please specify maximum number of worker nodes for AKS Cluster.
agent_vm_size  --> The size of the Virtual Machine, such as *Standard_DS1_v2*
os_disk_size_gb  --> The disk size of the Virtual Machine in GB *ex: 30*
subnet_prefixes  --> The address prefix to use for the subnet. *ex: ["10.10.1.0/24", "10.10.2.0/24"]*
```
Alternatively, client_id and client_secret can be exported as TF variables instead of passing as variable 

```
export TF_VAR_client_id=18262b84-XXXX-XXXX-XXXX-7f6191dc0607
export TF_VAR_client_secret=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
After applying the terraform plan, kube-config will be automatically stored as ~/.kube/config file

Note:
```
1. Not all the regions have multiple zones (ex:India, West US). So users need to provide the AZs list based on region in which resource group exists, as we are taking the location from the resource group instead of asking users to enter the location. 
    - for region central US, if they enter AZ as ["1", "2"] or ["1", "2", "3"], it will be fine.
    - for region central india, if they enter any thing other than [], it will fail.
2. Also, vm size (instance type) is also based on the location of resource group. terraform apply will be failed if proper type is not provided by user.
```
Above two failures will not occur during PLAN, failure happens only during APPLY.