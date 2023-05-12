variable "alarm_create" {
  type        = bool
  default     = false
  description = "Whether or not to create alarms"
}

variable "alarm_get_records" {
  type = object({
    create               = optional(bool, true)
    period               = optional(number, 60)
    evaluation_periods   = optional(number, 15)
    alarm_description    = optional(string, "This metric monitors kinesis get records successful records (percent)")
    datapoints_to_alarm  = optional(number, 10)
    threshold_percentage = optional(number, 99)
  })
  default = {
    create               = true
    period               = 60
    evaluation_periods   = 15
    alarm_description    = "This metric monitors kinesis get records successful records (percent)"
    datapoints_to_alarm  = 10
    threshold_percentage = 99
  }
  description = "Settings for the get records alarm"
}

variable "alarm_iterator_age_high" {
  type = object({
    create              = optional(bool, true)
    period              = optional(number, 60)
    evaluation_periods  = optional(number, 15)
    alarm_description   = optional(string, "This metric monitors kinesis iterator age")
    datapoints_to_alarm = optional(number, 10)
    threshold_seconds   = optional(number, 60)
  })
  default = {
    create              = true
    period              = 60
    evaluation_periods  = 15
    alarm_description   = "This metric monitors kinesis iterator age"
    datapoints_to_alarm = 10
    threshold_seconds   = 60
  }
  description = "Settings for the iterator age high alarm"
}

variable "alarm_put_records" {
  type = object({
    create               = optional(bool, true)
    period               = optional(number, 60)
    evaluation_periods   = optional(number, 15)
    alarm_description    = optional(string, "This metric monitors kinesis put records successful records (percent)")
    datapoints_to_alarm  = optional(number, 10)
    threshold_percentage = optional(number, 99)
  })
  default = {
    create               = true
    period               = 60
    evaluation_periods   = 15
    alarm_description    = "This metric monitors kinesis put records successful records (percent)"
    datapoints_to_alarm  = 10
    threshold_percentage = 99
  }
  description = "Settings for the put records alarm"
}

variable "alarm_read_bytes_high" {
  type = object({
    create               = optional(bool, true)
    period               = optional(number, 60)
    evaluation_periods   = optional(number, 15)
    alarm_description    = optional(string, "This metric monitors kinesis read bytes utilization")
    datapoints_to_alarm  = optional(number, 10)
    threshold_percentage = optional(number, 80)
  })
  default = {
    create               = true
    period               = 60
    evaluation_periods   = 15
    alarm_description    = "This metric monitors kinesis read bytes utilization"
    datapoints_to_alarm  = 10
    threshold_percentage = 80
  }
  description = "Settings for the read bytes high alarm"
}

variable "alarm_topic_arn" {
  type        = string
  default     = null
  description = "ARN of the AWS SNS topic for the CloudWatch alarms"
}

variable "alarm_write_bytes_high" {
  type = object({
    create               = optional(bool, true)
    period               = optional(number, 60)
    evaluation_periods   = optional(number, 15)
    alarm_description    = optional(string, "This metric monitors kinesis write bytes utilization")
    datapoints_to_alarm  = optional(number, 10)
    threshold_percentage = optional(number, 80)
  })
  default = {
    create               = true
    period               = 60
    evaluation_periods   = 15
    alarm_description    = "This metric monitors kinesis write bytes utilization"
    datapoints_to_alarm  = 10
    threshold_percentage = 80
  }
  description = "Settings for the write bytes high alarm"
}

variable "alarm_write_records_high" {
  type = object({
    create               = optional(bool, true)
    period               = optional(number, 60)
    evaluation_periods   = optional(number, 15)
    alarm_description    = optional(string, "This metric monitors kinesis write records utilization")
    datapoints_to_alarm  = optional(number, 10)
    threshold_percentage = optional(number, 80)
  })
  default = {
    create               = true
    period               = 60
    evaluation_periods   = 15
    alarm_description    = "This metric monitors kinesis write records utilization"
    datapoints_to_alarm  = 10
    threshold_percentage = 80
  }
  description = "Settings for the write records high alarm"
}

variable "buffer_interval" {
  type        = number
  default     = 300
  description = "(Optional) Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. The default value is 300."
}

variable "dynamic_partitioning_enabled" {
  type        = bool
  default     = false
  description = "Whether or not to use dynamic partitioning"
}

variable "dynamic_partitioning_lambda_transformer_function_arn" {
  type        = string
  default     = null
  description = "ARN of the Lambda function to transform the data for dynamic partitioning"
}

variable "dynamic_partitioning_lambda_transformer_function_name" {
  type        = string
  default     = null
  description = "Name of the Lambda function to transform the data for dynamic partitioning"
}

variable "dynamic_partitioning_processor_parameters" {
  type = set(object({
    parameter_name  = string
    parameter_value = any
  }))
  default     = []
  description = "Set of parameter for the dynamic partitioning processor"
}

variable "glue_database_name" {
  type        = string
  description = "Name of the Glue database to be used for your schema configuration"
}

variable "glue_table_name" {
  type        = string
  description = "Name of the Glue table to be used for your schema configuration"
}

variable "kinesis_forwarder_enabled" {
  type        = bool
  default     = true
  description = "Whether to subscribe to an sns topic to allow a kinesis forwarder lambda to put data into the stream"
}

variable "kinesis_forwarder_lambda_function_arn" {
  type        = string
  default     = null
  description = "ARN of the Lambda function to be used to forward data to the firehose stream"
}

variable "kinesis_forwarder_lambda_function_name" {
  type        = string
  default     = null
  description = "Name of the Lambda function to be used to forward data to the firehose stream"
}

variable "kinesis_forwarder_source_arn" {
  type        = string
  default     = null
  description = "ARN of the SNS topic to be used as data source by your lambda function"
}

variable "kinesis_retention_period" {
  type        = number
  default     = 24
  description = "How many hours to keep data of the stream"
}

variable "kinesis_shard_count" {
  type        = number
  default     = 1
  description = "How many shards to create for the input kinesis data stream"
}

variable "label_orders" {
  type = object({
    cloudwatch = optional(list(string)),
    iam        = optional(list(string)),
    kinesis    = optional(list(string)),
  })
  default     = {}
  description = "Overrides the `labels_order` for the different labels to modify ID elements appear in the `id`"
}

variable "log_group_retention_in_days" {
  type        = number
  default     = 30
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Defaults to 30 Days."
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 Bucket to put the kinesis datastream data into"
}

variable "s3_model_suffix" {
  type        = string
  default     = ""
  description = "Suffix to use for datalake key"
}

variable "s3_write_temp_year_partition" {
  type        = bool
  default     = false
  description = "Whether or not to write data to a temporary Year 9999 partition"
}
