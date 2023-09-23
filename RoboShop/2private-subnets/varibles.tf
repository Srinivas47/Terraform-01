variable "instance_type" {
  default = "t2.micro"
}
variable "ami" {
  default =var.ami_id.id
}