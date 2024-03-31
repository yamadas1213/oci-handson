data "template_file" "cloudinit" {
	template = "${file("${path.module}/cloudinit.yaml")}"
	vars ={
		tenancyid = "${var.tenancy_ocid}"
		region = "${var.region}"
	}
}

resource "oci_core_instance" "generated_oci_core_instance" {
    #Instance Name
    display_name = "yamadas-instance"

    #(Required) 配置
    compartment_id = var.compartment_id
    availability_domain = "TGjA:UK-LONDON-1-AD-1"
    #Optional
    fault_domain = "FAULT-DOMAIN-1"

    #Shape
    shape = "VM.Standard.E4.Flex"
	shape_config {
		memory_in_gbs = "8"
		ocpus = "1"
	}
    #Image
    source_details {
        #Oracle-Linux-8.8-2023.12.13-0
		source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaa4ijmnmoupcixncuuwlx7oqalzgbmrlyzdewn22fibel42lefgeqa"
		source_type = "image"
	}
    #Primary VNIC
    create_vnic_details {
		assign_ipv6ip = "false"
        #プライベートDNSを割り当てる
		assign_private_dns_record = "true"
		#パブリックIPv4アドレスの自動割当て
        assign_public_ip = "true"
        #Subnetの指定
		subnet_id = var.subnet_id
	}

    launch_options{
        #ネットワーク準仮想化
        network_type = "PARAVIRTUALIZED"
        #ブートボリューム準仮想化
        boot_volume_type = "PARAVIRTUALIZED"
        #転送中のデータ暗号化
        is_pv_encryption_in_transit_enabled = true
    }

    metadata = {
        ssh_authorized_keys = file("${path.module}/.ssh/yamadas-ssh-key.pub")
		#Cloudinitを指定する
		user_data = base64encode("${data.template_file.cloudinit.rendered}")
    }
	
    agent_config {
		is_management_disabled = "false"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Oracle Java Management Service"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "OS Management Service Agent"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Management Agent"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Custom Logs Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute RDMA GPU Monitoring"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Run Command"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute HPC RDMA Auto-Configuration"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Compute HPC RDMA Authentication"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Block Volume Management"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Bastion"
		}
	}
}
