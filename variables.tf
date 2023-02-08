variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "id vpc aws"
}
variable "subnet_public" {
  type        = string
  description = "subnet_public"
}

variable "instance_type" {
  type = string
  description = "Instance type of the EC2"
}

variable "availability_zone" {
  type    = string
}
