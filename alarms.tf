# Create SNS topic and subscription
resource "aws_sns_topic" "rds_db_topic" {
  name = var.sns_topic_name
  kms_master_key_id  = aws_kms_key.postgresql.arn
  tags = merge(
  {
    Name = var.sns_topic_name
  },
  var.standard_tags
  )
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.rds_db_topic.arn
  protocol  = "email"
  endpoint  = var.sns_topic_email
}

locals {
  db_instance_ids = {
    writer = aws_rds_cluster_instance.rds_cluster_instances[0].endpoint
    #reader = length(aws_rds_cluster_instance.rds_cluster_instances) > 1 ? aws_rds_cluster_instance.rds_cluster_instances[1].endpoint : ""
  }

  alarms = [
    {
      name                = "URGENT-CPUUsageAlarm >= 85%-${local.db_instance_ids.writer}"
      metric_name         = "CPUUtilization"
      threshold           = 85
      comparison_operator = "GreaterThanOrEqualToThreshold"
      description         = "Alarm when CPU usage exceeds 85% for ${local.db_instance_ids.writer}"
      DBInstanceIdentifier  = local.db_instance_ids.writer  
    },
    #{
    #  name                = "URGENT-CPUUsageAlarm >= 90%-${local.db_instance_ids.writer}"
    #  metric_name         = "CPUUtilization"
    #  threshold           = 90
    #  comparison_operator = "GreaterThanOrEqualToThreshold"
    #  description         = "Alarm when CPU usage exceeds 90% for ${local.db_instance_ids.writer}"
    #  DBInstanceIdentifier  = local.db_instance_ids.writer 
    #},
    {
      name                = "URGENT-CPUUsageAlarm >= 95-${local.db_instance_ids.writer}"
      metric_name         = "CPUUtilization"
      threshold           = 95
      comparison_operator = "GreaterThanOrEqualToThreshold"
      description         = "Alarm when CPU usage exceeds 95% for ${local.db_instance_ids.writer}"
      DBInstanceIdentifier  = local.db_instance_ids.writer 
    },
    {
      name                = "URGENT_FreeableMemoryAlarm_${local.db_instance_ids.writer}"
      metric_name         = "FreeableMemory"
      threshold           = 214958094
      comparison_operator = "LessThanOrEqualToThreshold"
      description         = "Alarm when freeable memory is less than or equal to 10% for ${local.db_instance_ids.writer}"
      DBInstanceIdentifier  = local.db_instance_ids.writer 
    },
    #{
    #  name                = "URGENT-CPUUsageAlarm >= 85%-${local.db_instance_ids.reader}"
    #  metric_name         = "CPUUtilization"
    #  threshold           = 85
    #  comparison_operator = "GreaterThanOrEqualToThreshold"
    #  description         = "Alarm when CPU usage exceeds 85% for ${local.db_instance_ids.reader}"
    #  DBInstanceIdentifier  = local.db_instance_ids.reader
    #},
    #{
    #  name                = "URGENT-CPUUsageAlarm >= 90%-${local.db_instance_ids.reader}"
    #  metric_name         = "CPUUtilization"
    #  threshold           = 90
    #  comparison_operator = "GreaterThanOrEqualToThreshold"
    #  description         = "Alarm when CPU usage exceeds 90% for ${local.db_instance_ids.reader}"
    #  DBInstanceIdentifier  = local.db_instance_ids.reader
    #},
    #{
    #  name                = "URGENT-CPUUsageAlarm >= 95-${local.db_instance_ids.reader}"
    #  metric_name         = "CPUUtilization"
    #  threshold           = 95
    #  comparison_operator = "GreaterThanOrEqualToThreshold"
    #  description         = "Alarm when CPU usage exceeds 95% for ${local.db_instance_ids.reader}"
    #  DBInstanceIdentifier  = local.db_instance_ids.reader
    #},
    #{
    #  name                = "URGENT_FreeableMemoryAlarm_${local.db_instance_ids.reader}"
    #  metric_name         = "FreeableMemory"
    #  threshold           = 644245094
    #  comparison_operator = "LessThanOrEqualToThreshold"
    #  description         = "Alarm when freeable memory is less than or equal to 10% for ${local.db_instance_ids.reader}"
    #  DBInstanceIdentifier  = local.db_instance_ids.reader
    #}
      
  ]

}

resource "aws_cloudwatch_metric_alarm" "alarms" {
  count = length(local.alarms)

  alarm_name          = local.alarms[count.index].name
  comparison_operator = local.alarms[count.index].comparison_operator
  evaluation_periods  = 1
  metric_name         = local.alarms[count.index].metric_name
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = local.alarms[count.index].threshold
  alarm_description   = local.alarms[count.index].description

  dimensions = {
    DBInstanceIdentifier = local.alarms[count.index].DBInstanceIdentifier
  }

  alarm_actions       = [aws_sns_topic.rds_db_topic.arn]
}
