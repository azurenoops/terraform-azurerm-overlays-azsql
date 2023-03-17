# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "add_tags" {
  description = "Map of custom tags."
  type        = map(string)
  default     = {}
}

variable "server_add_tags" {
  description = "Extra tags to add on SQL Server or ElasticPool"
  type        = map(string)
  default     = {}
}

variable "elastic_pool_add_tags" {
  description = "Extra tags to add on ElasticPool"
  type        = map(string)
  default     = {}
}