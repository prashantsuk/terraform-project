# main.tf

module "my_vpc" {
  source             = "./vpc_module"
  vpc_name           = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]  # Update with your desired subnet CIDR blocks
}
