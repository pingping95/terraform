// Tagging
variable "tags" {
  type    = map(any)
  default = {}
}

variable "owner" {
  type        = string
  description = "Owner tag"
}

variable "domain_name" {
  default = "pingping2.shop"
}