# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "boundary_role" "global_anon_listing" {
  scope_id = boundary_scope.global.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

resource "boundary_role" "org_anon_listing" {
  scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

resource "boundary_role" "org_readonly" {
  name           = "readonly"
  description    = "Read-only role"
  scope_id       = boundary_scope.global.id
  grant_scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=*;actions=read"
  ]
  principal_ids = [
    boundary_managed_group.developer.id,
    boundary_managed_group.database.id
  ]
}

resource "boundary_role" "db_admin" {
  name           = "${boundary_scope.db_infra.id}-admin"
  description    = "Administrator role for ${boundary_scope.db_infra.id}"
  scope_id       = boundary_scope.org.id
  grant_scope_id = boundary_scope.db_infra.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [
    boundary_managed_group.database.id
  ]
}

# Adds an org-level role granting administrative permissions within the application project
resource "boundary_role" "application" {
  name           = "${boundary_scope.application.id}-admin"
  description    = "Administrator role for ${boundary_scope.application.id}"
  scope_id       = boundary_scope.org.id
  grant_scope_id = boundary_scope.application.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [
    boundary_managed_group.developer.id
  ]
}