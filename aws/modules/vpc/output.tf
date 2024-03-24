# output "sg_id" {
#   value = module.vpc.aws_security_group.default.id
# }

# output "public_subnet_list" {
#   value = module.vpc.aws_subnet.public_subnet.*.id
# }
# output "private_subnet_list" {
#   value = module.vpc.aws_subnet.private_subnet.*.id
# }

# output "vpc_id" {
#   value = module.vpc.aws_vpc.vpc.id
# }

# output "security_group_id" {
#   value = module.vpc.aws_security_group.default.id
# }

# output "aws_lb_target_group_arn" {
#   value = module.vpc.aws_lb_target_group.my-web-tg.arn
# }

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}