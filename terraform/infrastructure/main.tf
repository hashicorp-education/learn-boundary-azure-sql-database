# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  controller_subnet_id = module.vnet.vnet_subnets[0]
  worker_subnet_id     = module.vnet.vnet_subnets[1]
  backend_subnet_id    = module.vnet.vnet_subnets[2]
  vault_subnet_id      = module.vnet.vnet_subnets[3]
}

resource "time_sleep" "wait" {
  depends_on      = [module.vnet]
  create_duration = "30s"
}