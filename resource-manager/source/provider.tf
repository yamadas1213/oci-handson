provider "oci" {
   region = "${var.region}"
}

terraform{
   required_version = ">=1.2.9"
   required_providers{
      oci ={
         source = "oracle/oci"
         version = ">=5.0.0"
      }
   }
}
