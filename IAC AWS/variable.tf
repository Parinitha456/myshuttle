variable "aws_region" {
  type = string
  description = "AWS Region to create resource"
}

variable "cluster-name" {
  type = string
  description = "Cluster name of AKS"
}

variable "access_key"{
  type = string
  description = "Access key"
}

variable "secret_key"{
  type = string
  description = "Secrete key"
}

variable "demo-nodename"{
  type = string
  description = "demo-nodename"
}
variable "node_group_name"{
  type = string
  description = "node_group_name"
}