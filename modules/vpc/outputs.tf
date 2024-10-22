output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg_v2.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg_v2.id
}