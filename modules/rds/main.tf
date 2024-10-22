resource "aws_db_instance" "postgres" {
  identifier              = var.db_name
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = aws_secretsmanager_secret_version.database_password_version.secret_string
  backup_retention_period = var.db_backup_retention

  # Perhaps a snapshot of db should be created in a production environment (?) It is worth highlighting the possible evaluation
  skip_final_snapshot = true
  publicly_accessible = false

  # Availability Zones (AZs) can be evaluate for use in a production environment (?)
  multi_az          = false
  storage_encrypted = true

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "rds-postgres-instance-${var.env}"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group-${var.env}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "rds-subnet-group-${var.env}"
  }
}

resource "aws_db_parameter_group" "rds_params" {
  name   = var.param_group_name
  family = "postgres16"

  lifecycle {
    create_before_destroy = true
  }
}