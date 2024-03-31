# provider変数の設定
variable "tenancy_ocid" {
    sensitive = true
}
variable "user_ocid" {
    sensitive = true
}
variable "fingerprint" {
    sensitive = true
}
variable "private_key_path" {
    sensitive = true
}
variable "region" {
    sensitive = true
}

# main変数の設定
variable "compartment_id" {
    sensitive = true
}
#main.tfのsubnet_idを受け取る変数設定
variable "subnet_id" {
    sensitive = true
}