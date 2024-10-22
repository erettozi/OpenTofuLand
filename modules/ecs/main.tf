resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.organization}-${var.env}"
}

# ------------------------------------------------------------------------------
# Task Execution Role
# ------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSTaskExecutionRole-${var.organization}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_role_policy" {
  name = "ECSTaskExecutionRolePolicy-${var.organization}-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : var.db_password_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ------------------------------------------------------------------------------
# Task Role
# ------------------------------------------------------------------------------

resource "aws_iam_role" "api_task_role" {
  name = "API-TaskRole-${var.organization}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "website_api_task_policy_attachment" {
  role       = aws_iam_role.api_task_role.name
  policy_arn = var.web_api_policy_arn
}

# ------------------------------------------------------------------------------
# CloudWatch Log Group
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/ecs-${var.organization}-${var.env}"
  retention_in_days = 7

  tags = {
    Environment = var.env
  }
}