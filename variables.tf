variable "environment" {
  default = "test"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "cidr_blocks" {
  default = "10.10.0.0/16"
}
variable "app_cidr_blocks" {
  default = "10.10.0.0/16"
}
variable "application" {
  default = "random"

}
variable "customer" {
  default = "internal"
}
variable "s3_bucket" {
  default = "fcs-app1-cac1abcd1"
}
variable "instance_count" {
  default = 1
}
#variable "zone_id" {}
#variable "private_key" {}
variable "key_name" {
  default = "keyki"
}