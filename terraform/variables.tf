# provided by the GitLab CI template
variable "environment_type" {
  description = "Environment Type"
  type = string
  default = "dev"
}

# provided by the GitLab CI template
variable "environment_name" {
  description = "Environment Name"
  type = string
  default = "dev"
}

# provided by the GitLab CI template
variable "environment_slug" {
  description = "Environment FQDN"
  type = string
  default = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t2.micro"
}

variable "ssh_pub_key_file" {
  description = "SSH public key file"
  type = string
  sensitive = true
}

variable "ssh_user_name" {
  description = "SSH username"
  type = string
  default = "ec2-user"
}
