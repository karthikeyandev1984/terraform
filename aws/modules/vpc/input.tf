variable "environment" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

# variable "ecs_task_execution_role_name" {
#   description = "ECS task execution role name"
# }


# variable "public_subnet_list" {
  
# }

# variable "vpc_id" {
  
# }

# variable security_group_id {

# }

# variable "aws_lb_target_group_arn" {
  
# }

