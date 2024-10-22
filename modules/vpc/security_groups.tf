# ------------------------------------------------------------------------------
# Security Group for ECS app
# ------------------------------------------------------------------------------
resource "aws_security_group" "ecs_sg_v2" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "ecs-sg-${var.env}"
  description            = "Security group for ecs app"
  revoke_rules_on_delete = true
}

# ------------------------------------------------------------------------------
# ECS app Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_alb_ingress_v2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ALB"
  security_group_id        = aws_security_group.ecs_sg_v2.id
  source_security_group_id = aws_security_group.alb_sg_v2.id
}
resource "aws_security_group_rule" "ecs_self_ingress_v2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from self SG"
  security_group_id        = aws_security_group.ecs_sg_v2.id
  source_security_group_id = aws_security_group.ecs_sg_v2.id
}

# ------------------------------------------------------------------------------
# ECS app Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_all_egress_v2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg_v2.id
  cidr_blocks       = ["0.0.0.0/0"]
}



# ------------------------------------------------------------------------------
# Security Group for alb
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg_v2" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "alb-sg-${var.env}"
  description            = "Security group for alb"
  revoke_rules_on_delete = true
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_http_ingress_v2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow http inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg_v2.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_https_ingress_v2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow https inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg_v2.id
  cidr_blocks       = ["0.0.0.0/0"]
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_egress_v2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from alb"
  security_group_id = aws_security_group.alb_sg_v2.id
  cidr_blocks       = ["0.0.0.0/0"]
}