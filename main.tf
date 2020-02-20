
data "terraform_remote_state" "azure-policy-demo" {
  backend = "remote"

  config = {
    organization = "SAP_Multicloud"
    workspaces = {
      name = "azure-policies-demo"
    }
  }
}




data "azurerm_subscription" "current" {}



data "template_file" "requiredTag_policy_assign" {
  template = <<PARAMETERS
{
    "tagName": {
        "value": "${var.requiredTag}"
    }
}

PARAMETERS
}



resource "azurerm_policy_assignment" "requiredTag" {
  count                = var.policy_1_enabled
  name                 = "Audit-RequiredTag-${var.requiredTag}"
  display_name         = "Assign Required Tag '${var.requiredTag}'"
  description          = "Assignment of Required Tag Policy for '${var.requiredTag}'"
  policy_definition_id = data.terraform_remote_state.azure-policy-demo.outputs.policy_1_id
  scope                = "${data.azurerm_subscription.current.id}"
  parameters           = "${data.template_file.requiredTag_policy_assign.rendered}"
  
  }
  
 
