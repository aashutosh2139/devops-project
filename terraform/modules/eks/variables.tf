variable "project_name"     {}
variable "vpc_id"           {}
variable "private_subnets"  { type = list(string) }
variable "public_subnets"   { type = list(string) }
variable "eks_node_type"    { default = "t3.medium" }
variable "eks_desired_size" { default = 2 }
variable "eks_min_size"     { default = 1 }
variable "eks_max_size"     { default = 4 }
