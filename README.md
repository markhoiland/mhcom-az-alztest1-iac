# Azure Landing Zones with Terraform

This repository contains Infrastructure as Code (IaC) for deploying Azure Landing Zones using the Azure Verified Modules (AVM) pattern. It implements a secure CI/CD pipeline using GitHub Actions with OpenID Connect (OIDC) authentication.

## 📁 Repository Structure

```
├── Landing-Zone/                    # Core ALZ hierarchy and policies
│   ├── main.tf                      # Main configuration using avm-ptn-alz
│   ├── variables.tf                 # Variable definitions
│   ├── outputs.tf                   # Output definitions
│   └── terraform.tfvars.example     # Example variable values
├── Management/                      # ALZ Management resources
│   ├── main.tf                      # Main configuration using avm-ptn-alz-management
│   ├── variables.tf                 # Variable definitions
│   ├── outputs.tf                   # Output definitions
│   └── terraform.tfvars.example     # Example variable values
├── .github/workflows/               # GitHub Actions CI/CD
│   ├── terraform-plan.yml           # PR validation and planning
│   ├── terraform-apply.yml          # Apply on merge to main
│   └── terraform-destroy.yml        # Manual destroy workflow
└── README.md                        # This file
```

## 🏗️ Architecture Overview

### Landing-Zone Module
Uses [Azure/terraform-azurerm-avm-ptn-alz](https://github.com/Azure/terraform-azurerm-avm-ptn-alz) to deploy:
- Management Group hierarchy following ALZ architecture
- Policy definitions and assignments
- Role definitions
- Subscription placement

### Management Module
Uses [Azure/terraform-azurerm-avm-ptn-alz-management](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management) to deploy:
- Log Analytics Workspace
- Automation Account
- Data Collection Rules
- Microsoft Sentinel (optional)
- User Assigned Managed Identities

## 🔐 Prerequisites

Before using this repository, you need to configure:
1. Azure subscription(s) with appropriate permissions
2. Microsoft Entra ID app registration with OIDC federation
3. GitHub repository secrets

---

## 🔑 Setting Up OpenID Connect (OIDC) Authentication

OIDC enables secure, secretless authentication from GitHub Actions to Azure. No client secrets or certificates are stored in GitHub.

### Step 1: Create App Registration in Microsoft Entra ID

1. **Navigate to Microsoft Entra ID**
   - Go to [Azure Portal](https://portal.azure.com)
   - Select **Microsoft Entra ID** from the left menu
   - Click **App registrations** → **New registration**

2. **Register the Application**
   - **Name**: `github-actions-alz-deployment` (or your preferred name)
   - **Supported account types**: Accounts in this organizational directory only
   - Click **Register**

3. **Note the Application Details**
   - Copy the **Application (client) ID** → This is your `AZURE_CLIENT_ID`
   - Copy the **Directory (tenant) ID** → This is your `AZURE_TENANT_ID`

### Step 2: Configure Federated Credentials

1. **Navigate to Federated Credentials**
   - In your App Registration, go to **Certificates & secrets**
   - Select the **Federated credentials** tab
   - Click **Add credential**

2. **Configure for GitHub Actions (Main Branch)**
   - **Federated credential scenario**: GitHub Actions deploying Azure resources
   - **Organization**: `<your-github-org-or-username>`
   - **Repository**: `<your-repo-name>`
   - **Entity type**: Branch
   - **Branch**: `main`
   - **Name**: `github-actions-main`
   - Click **Add**

3. **Configure for Pull Requests** (Optional but recommended)
   - Click **Add credential** again
   - **Federated credential scenario**: GitHub Actions deploying Azure resources
   - **Organization**: `<your-github-org-or-username>`
   - **Repository**: `<your-repo-name>`
   - **Entity type**: Pull Request
   - **Name**: `github-actions-pr`
   - Click **Add**

4. **Configure for Environments** (Optional)
   - For environment-specific deployments:
   - **Entity type**: Environment
   - **Environment**: `production`
   - **Name**: `github-actions-production`

### Step 3: Assign Azure RBAC Permissions

1. **Navigate to Subscription**
   - Go to **Subscriptions** in Azure Portal
   - Select your target subscription

2. **Add Role Assignment**
   - Click **Access control (IAM)** → **Add role assignment**
   - Select role based on your needs:
     - **Owner** - For full ALZ deployment (recommended for initial setup)
     - **Contributor** + **User Access Administrator** - Alternative for resource deployment
   - Select **User, group, or service principal**
   - Search for your app registration name
   - Click **Review + assign**

3. **Management Group Permissions** (Required for Landing-Zone)
   - Navigate to **Management groups**
   - Select the root management group (or tenant root group)
   - Click **Access control (IAM)** → **Add role assignment**
   - Assign **Owner** or equivalent permissions to your app registration

### Step 4: Configure GitHub Repository Secrets

1. **Navigate to GitHub Repository Settings**
   - Go to your GitHub repository
   - Click **Settings** → **Secrets and variables** → **Actions**

2. **Add Repository Secrets**
   
   | Secret Name | Value | Description |
   |-------------|-------|-------------|
   | `AZURE_CLIENT_ID` | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Application (client) ID from Entra ID |
   | `AZURE_TENANT_ID` | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Directory (tenant) ID from Entra ID |
   | `AZURE_SUBSCRIPTION_ID` | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Target Azure Subscription ID |

3. **Create GitHub Environments** (Recommended)
   - Go to **Settings** → **Environments**
   - Create environments: `production`, `production-destroy`
   - Configure protection rules (required reviewers, wait timer)

### Step 5: Verify Configuration

Run the following Azure CLI commands to verify your setup:

```bash
# Login to Azure
az login

# Verify the app registration
az ad app show --id <AZURE_CLIENT_ID> --query "{Name:displayName, AppId:appId, TenantId:appOwnerOrganizationId}"

# Check federated credentials
az ad app federated-credential list --id <AZURE_CLIENT_ID> --query "[].{Name:name, Subject:subject, Issuer:issuer}"

# Verify RBAC assignments (subscription level)
az role assignment list --assignee <AZURE_CLIENT_ID> --subscription <AZURE_SUBSCRIPTION_ID> --query "[].{Role:roleDefinitionName, Scope:scope}"

# Verify RBAC assignments (management group level)
az role assignment list --assignee <AZURE_CLIENT_ID> --scope "/providers/Microsoft.Management/managementGroups/<TENANT_ID>"
```

---

## 🚀 Getting Started

### 1. Clone and Configure

```bash
# Clone the repository
git clone https://github.com/<your-org>/<your-repo>.git
cd <your-repo>

# Navigate to the desired configuration
cd Landing-Zone  # or Management

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Configure Remote State (Recommended)

Create an Azure Storage Account for Terraform state:

```bash
# Set variables
RESOURCE_GROUP="rg-terraform-state"
STORAGE_ACCOUNT="stterraformstate$RANDOM"
CONTAINER="tfstate"
LOCATION="eastus"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# Create container
az storage container create \
  --name $CONTAINER \
  --account-name $STORAGE_ACCOUNT
```

Update the backend configuration in `main.tf`:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "<your-storage-account>"
  container_name       = "tfstate"
  key                  = "alz-landing-zone.tfstate"  # or alz-management.tfstate
}
```

### 3. Local Development

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan -out=tfplan

# Apply changes (when ready)
terraform apply tfplan
```

---

## 🔄 CI/CD Workflows

### Terraform Plan (Pull Requests)
- **Trigger**: Pull requests targeting `main` branch
- **Actions**: 
  - Runs `terraform fmt` check
  - Runs `terraform init` and `validate`
  - Runs `terraform plan`
  - Posts plan summary as PR comment
  - Uploads plan artifact

### Terraform Apply (Main Branch)
- **Trigger**: Push to `main` branch or manual dispatch
- **Actions**:
  - Runs `terraform init`, `validate`, and `plan`
  - Applies changes automatically (on push) or with approval (manual)
- **Environment**: `production` (with optional protection rules)

### Terraform Destroy (Manual Only)
- **Trigger**: Manual workflow dispatch only
- **Safety**: Requires typing "DESTROY" to confirm
- **Environment**: `production-destroy` (with protection rules)

---

## 📋 Configuration Guide

### Landing-Zone Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `root_management_group_id` | Yes | - | Tenant root management group ID |
| `default_location` | No | `eastus` | Default Azure region |
| `subscription_placement` | No | `{}` | Map of subscriptions to management groups |
| `architecture_overrides` | No | `{}` | Override default ALZ settings |
| `enable_telemetry` | No | `true` | Enable module telemetry |

### Management Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `automation_account_name` | Yes | - | Name for Automation Account |
| `log_analytics_workspace_name` | Yes | - | Name for Log Analytics Workspace |
| `resource_group_name` | Yes | - | Name for resource group |
| `location` | No | `eastus` | Azure region |
| `sentinel_onboarding` | No | `null` | Enable Microsoft Sentinel |
| `log_analytics_workspace_retention_in_days` | No | `30` | Log retention period |

---

## 🛡️ Security Best Practices

1. **OIDC Authentication**: No long-lived credentials stored in GitHub
2. **Least Privilege**: Assign minimum required permissions
3. **Branch Protection**: Require PR reviews before merging to main
4. **Environment Protection**: Configure reviewers for production deployments
5. **State Encryption**: Enable encryption for Terraform state storage
6. **Audit Logging**: Enable Azure Activity Logs and GitHub Audit Logs

---

## 🔧 Troubleshooting

### Common Issues

**Error: OIDC token not found**
- Ensure `id-token: write` permission is set in workflow
- Verify federated credentials match repository/branch/environment

**Error: AuthorizationFailed**
- Check RBAC assignments at correct scope
- Verify app registration has required permissions
- Allow time for permission propagation (up to 5 minutes)

**Error: ManagementGroupNotFound**
- Ensure `root_management_group_id` is correct
- Verify permissions on management group hierarchy

**Error: Terraform state lock**
- Check if another process is running
- Verify storage account access permissions

### Debug Steps

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log

# Test Azure authentication
az login --service-principal -u <CLIENT_ID> -t <TENANT_ID> --federated-token <token>

# Verify provider configuration
terraform providers
```

---

## 📚 Additional Resources

- [Azure Landing Zones Documentation](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)
- [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)
- [AVM ALZ Pattern Module](https://github.com/Azure/terraform-azurerm-avm-ptn-alz)
- [AVM ALZ Management Module](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management)
- [GitHub Actions OIDC](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## ⚠️ Important Notes

- **Management Group Deployment**: The Landing-Zone module deploys management groups and policies at the tenant level. Ensure you have appropriate permissions.
- **Policy Assignments**: Some policies require parameter values (e.g., Log Analytics Workspace ID). Configure `policy_default_values` accordingly.
- **Destroy Operations**: Use the destroy workflow with extreme caution. Management groups and policies affect the entire Azure environment.
- **State Management**: Always use remote state with locking for team collaboration.
