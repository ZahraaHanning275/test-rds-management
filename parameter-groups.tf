resource "aws_rds_cluster_parameter_group" "cluster_prod_parameter_group" {
  count = var.environment == "Prod" ? 1 : 0
  name  = "${var.db_prefix}-cluster-pg"
  family = "postgres16"  # Use the default PostgreSQL engine family

  tags = {
    Name = "${var.db_prefix}-cluster-pg"
  }
}

resource "aws_rds_cluster_parameter_group" "cluster_nonprod_parameter_group" {
  count = var.environment == "Dev" ? 1 : 0
  name  = "${var.db_prefix}-cluster-pg"
  family = "postgres16"  # Use the default PostgreSQL engine family

  tags = {
    Name = "${var.db_prefix}-cluster-pg"
  }
}

resource "aws_db_parameter_group" "db_prod_parameter_group" {
  count = var.environment == "Prod" ? 1 : 0
  name  = var.db_parameter_group_name
  family = "postgres16"  # PostgreSQL 16 (or your desired version)

  tags = {
    Name = "${var.db_prefix}-pg"
  }
}

resource "aws_db_parameter_group" "db_nonprod_parameter_group" {
  count = var.environment == "Dev" ? 1 : 0
  name  = var.db_parameter_group_name
  family = "postgres16"  # PostgreSQL 16 (or your desired version)

  tags = {
    Name = "${var.db_prefix}-pg"
  }
}

