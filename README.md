# rds_terraform

This repository is designed to create and manage AWS RDS PostgreSQL clusters and instances. It also provisions the necessary secrets in AWS Secrets Manager, enabling automatic password rotation every 90 days. Additionally, the repository configures a default parameter group for the RDS cluster and instances. It includes the creation of a Customer Managed KMS key to secure both the database and its associated secrets. Secrets contain the login details for database users.

Please note that for the auto-rotation of secrets, a VPC Endpoint needs to be created to allow communication between the Secrets Manager and the auto-rotation Lambda function. The respective security groups of both the Lambda function and the VPC Endpoint needs to be updated.
