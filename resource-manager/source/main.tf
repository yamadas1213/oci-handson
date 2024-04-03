module "vcn"{
source = "./modules/vcn"

#必須情報
region = var.region
tenancy_ocid = var.tenancy_ocid
compartment_id = var.compartment_id
}

module "compute"{
source = "./modules/compute"

# VCNで作成したパブリックサブネットのサブネットIDをComputeに渡す
# VCN配下のoutput.tfで定義したsubnetidのvalueが渡ってくる
subnet_id = module.vcn.subnet_id

#必須情報
region = var.region
tenancy_ocid = var.tenancy_ocid
compartment_id = var.compartment_id
}
