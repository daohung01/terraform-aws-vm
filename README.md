# How to use module 


          module "vm" {
            source  = "daohung01/vm/aws"
            version = "1.0.1"
            # insert the 3 required variables here
            subnet_public = "10.0.0.3/24"
            instance_type = "t2.micro"
            availability_zone = "us-west-2a"
          }
