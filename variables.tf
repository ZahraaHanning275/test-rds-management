variable "db_user" {
  description = "The user for the RDS database."
  type        = string
}

variable "password" {
  description = "The password for the RDS database."
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment this is targeted for"
  type        = string  
}

variable "standard_tags" {
  description = "Standard tags that are used for all AWS resources"
  type = map(string)
  default = {
    Project=""
    ManagedBy=""
    Confidentiality="C3"
	  SecurityZone="D1"
    TaggingVersion="v2.0"
    BusinessService=""    
  }
}

variable "db_prefix" {
  description = "Prefix for the names of the resources for the Fraud Assurance DB"
  type = string  
}

variable "instance_count" {
  type = number
  default = 2
  description = "Count of db instances in Aurora cluster"
}

variable "vpc_name" {
  type = string
  default = ""
  description = "VPC Name"
}

variable "subnets" {
  type = list(string)
  default = []
  description = "Subnet Id's for the region"
}

variable "backup_window" {
  description = "Timeslot when backup must be started"
  type = string  
}

variable "skip_final_snapshot" {
  type = bool
  default = false
  description = "Should Final snapshot be skipped before cluster is destroyed"
}

variable "snapshot_retention_periods" {
  type = string
  default = 7
  description = "Period (in days) to store DB snapshot"
}

variable "engine" {
  description = "DB engine of the db instance"
  type = string  
}

variable "engine_version" {
  description = "DB engine version of the db instance"
  type = string  
}

variable "instance_class" {
  description = "Instance class of the db instance"
  type = string  
}

variable "storage_size" {
  type = number
  description = "The storage size to allocate to the db instance"
}

variable "storage_type" {
  description = "The storage type of the db instance"
  type = string  
}

variable "deletion_protection" {
  type = bool
  description = "Prevents db from accidently being deleted"
}

variable "storage_encrypted" {
  type = bool
  description = "Encrypts storage data"
}

variable "apply_immediately" {
  type = bool
  description = "Applies db modifications immediat`ely"
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
  default = []
  description = "Logs to be exported to Cloudwatch"
}

variable "iops" {
  description = "IOPS to be provisioned"
  type = number  
}

variable "maintenance_window" {
  description = "Maintenance window for db changes"
  type = string  
}

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval (secs)"
  type = number  
}

variable "performance_insights_enabled" {
  type = bool
  description = "Performance Insights switch"
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention (days)"
  type = number  
}

variable "option_group_name" {
  description = "Option group for CVM dbs"
  type = string  
}

variable "audit_file_rotations" {
  description = "Number of audit logs to keep"
  type = number  
}

variable "kms_key_alias" {
  description = "Alias for postgresql KMS key"
  type = string
}

variable "account_role" {
  type          = string  
}

variable "aws_availability_zones" {
  type = list(string)
  default = []
  description = "Availability zones in the regions"
}

variable "dbadmin_role" {
  type = string
  description = "ARN of the DBAdmin role"
}

variable "sns_topic_name" {
  type = string
  description = "Name for the SNS Topic"
}

variable "sns_topic_email" {
  type = string
  description = "Email address that SNS notificatins will be sent to"
}

variable "secrets_key_alias" {
  type = string
  description = "The alias for the RDS secrets key alias"
}

#variable "postgresql_rotation_lambda" {
  #type = string
  #description = "The alias for the Aurora postgresql secrets key alias"
#}

variable "rds_secrets" {
  description = "Map of RDS secrets with connection details."
  type = map(object({
    description = string
    username    = string
    password    = string
    engine      = string
    host        = string
    port        = string
  }))
}


#variable "rotation_lambda_arn" {
  #type = string
#}

variable "db_parameter_group_name" {
  type = string
}

