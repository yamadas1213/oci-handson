# provider変数の設定
variable "tenancy_ocid" {
    sensitive = true
}
variable "region" {
    sensitive = true
}
# main変数の設定
variable "compartment_id" {
    sensitive = true
}
