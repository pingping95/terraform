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

variable "cname" {
  description = "Domain Name`s Cname records"
  type = list(string)
  default = []
}