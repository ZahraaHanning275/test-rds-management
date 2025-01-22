#resource "aws_db_option_group" "db_option_group" {
#  name                     = var.option_group_name
#  option_group_description = "CVM Option Group"
#  engine_name              = var.engine
#  major_engine_version     = "3"
#
#  option {
#    option_name = "MARIADB_AUDIT_PLUGIN"
#
#	option_settings {
#      name  = "SERVER_AUDIT_FILE_ROTATE_SIZE"
#      value = 1000000
#    }
#
#	option_settings {
#      name  = "SERVER_AUDIT_FILE_ROTATIONS"
#      value = var.audit_file_rotations
#    }
#
#	option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "CONNECT"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "QUERY"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "TABLE"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "QUERY_DDL"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "QUERY_DML"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "QUERY_DML_NO_SELECT"
#    }
#
#    option_settings {
#      name  = "SERVER_AUDIT_EVENTS"
#      value = "QUERY_DCL"
#    }
#
#	option_settings {
#      name  = "SERVER_AUDIT_QUERY_LOG_LIMIT"
#      value = 1024
#    }
#  }
#
#  tags = {
#         Name = "CVM option group"
#  }
#}