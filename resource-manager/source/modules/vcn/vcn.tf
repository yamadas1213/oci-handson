# vcn_yamadas
resource "oci_core_vcn" "vcn_yamadas" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "vcnyamadas"
  compartment_id = var.compartment_id
  display_name   = "vcn_yamadas"
}

# test_internet_gateway
resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "testInternetGateway"
  vcn_id         = oci_core_vcn.vcn_yamadas.id
}
# Default Route Table, Add Internet Gateway
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn_yamadas.default_route_table_id
  display_name               = "defaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

# Service Gatewayのservice_id用にOracle Cloud Infrastructure Coreサービスのサービスのリストを取得する
data "oci_core_services" "test_services" {
    filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
# Service Gateway
resource "oci_core_service_gateway" "test_service_gateway" {
    #Required
    compartment_id = var.compartment_id
    services {
        #Required
        service_id = data.oci_core_services.test_services.services.0.id
    }
    vcn_id = oci_core_vcn.vcn_yamadas.id

    #Optional
    display_name = "testServiceGateway"
}

# NAT Gateway
resource "oci_core_nat_gateway" "test_nat_gateway" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn_yamadas.id
    display_name = "testNATGateway"
}

# Private Route Table, Add Service Gateway, NAT Gateway
resource "oci_core_route_table" "private" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn_yamadas.id
    #Optional
    display_name   = "privateRouteTable"
  # Add Service Gateway
  route_rules {
    #宛先にリージョン内のOSNサービス
    destination       = data.oci_core_services.test_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.test_service_gateway.id
  }
  # Add NAT Gateway
  route_rules {
    #宛先に"0.0.0.0/0"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.test_nat_gateway.id
  }
}

# Default Security List
resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.vcn_yamadas.default_security_list_id
  display_name               = "defaultSecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      type = 3
      code = 4
    }
  }
  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "10.0.0.0/16"
    stateless = false

    icmp_options {
      type = 3
    }
  }
}

# Private Security List
resource "oci_core_security_list" "private_security_list" {
  #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn_yamadas.id
 #Optional
    display_name = "PrivateSecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  // allow inbound ssh traffic from Public Subnet
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "10.0.0.0/16"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      type = 3
      code = 4
    }
  }
  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "10.0.0.0/16"
    stateless = false

    icmp_options {
      type = 3
    }
  }
}

# Public Subnet
resource "oci_core_subnet" "regional_public_subnet" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "regional_public_subnet"
  dns_label         = "pubsubnet"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn_yamadas.id
  security_list_ids = [oci_core_vcn.vcn_yamadas.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn_yamadas.default_route_table_id
  dhcp_options_id   = oci_core_vcn.vcn_yamadas.default_dhcp_options_id
}
# Private Subnet
resource "oci_core_subnet" "regional_private_subnet" {
  cidr_block        = "10.0.2.0/24"
  display_name      = "regional_private_subnet"
  dns_label         = "prisubnet"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn_yamadas.id
  security_list_ids = [oci_core_security_list.private_security_list.id]
  route_table_id    = oci_core_route_table.private.id
  prohibit_internet_ingress    = true
}