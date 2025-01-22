terraform { 
  cloud { 
    
    organization = "" 

    workspaces { 
      name = "RDS_Management" 
    } 
  } 

  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.31.0"
      }
    }

    required_version = "~> 1.2"
  }

provider "aws" {
  region  = "eu-west-1"

  #default_tags {
    #tags = var.standard_tags
  #}
}

data "aws_vpc" "current" {
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${var.db_prefix}-cluster"
  //db_cluster_instance_class       = var.instance_class
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = "${var.db_prefix}-final-snapshot"
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window
  backup_retention_period         = var.snapshot_retention_periods
  #db_cluster_parameter_group_name = var.environment == "Dev" ? aws_rds_cluster_parameter_group.cluster_prod_parameter_group[0].name : aws_rds_cluster_parameter_group.cluster_nonprod_parameter_group[0].name
  vpc_security_group_ids          = ["sg-0ae2116c8789eab56"]
  copy_tags_to_snapshot           = true
  deletion_protection             = var.deletion_protection
  //allocated_storage               = var.storage_size
  storage_encrypted               = var.storage_encrypted
  storage_type                    = var.storage_type
  kms_key_id                      = aws_kms_key.postgresql.arn
  apply_immediately               = var.apply_immediately
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  //iops                            = var.iops
  availability_zones              = var.aws_availability_zones
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  master_username                 = var.db_user
  master_password                 = var.password

  tags = {
    Name = "${var.db_prefix}-cluster"
  }

  lifecycle {
    ignore_changes = [availability_zones]
  }
}

resource "aws_rds_cluster_instance" "rds_cluster_instances" {
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = true
  cluster_identifier                    = aws_rds_cluster.rds_cluster.id
  count                                 = var.instance_count
  engine                                = aws_rds_cluster.rds_cluster.engine
  engine_version                        = aws_rds_cluster.rds_cluster.engine_version
  identifier                            = "${var.db_prefix}-db-${count.index}"
  instance_class                        = var.instance_class
  #db_parameter_group_name               = var.environment == "Dev" ? aws_db_parameter_group.db_prod_parameter_group[0].name : aws_db_parameter_group.db_nonprod_parameter_group[0].name
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet_group.name
  copy_tags_to_snapshot                 = true
  monitoring_interval                   = var.monitoring_interval
  #performance_insights_enabled          = var.performance_insights_enabled
  #performance_insights_retention_period = var.performance_insights_retention_period

  tags = {
    Name = "${var.db_prefix}-db-${count.index}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_prefix}-sng"
  subnet_ids = var.subnets
  tags = {
         Name = "${var.db_prefix}-sng"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.db_prefix}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.216.6.0/23", "100.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
         Name = "${var.db_prefix}-sg"
  }
}