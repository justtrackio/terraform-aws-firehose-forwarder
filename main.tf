locals {
  datalake_s3_key_prefix = "datalake/${module.this.attributes[0]}${var.s3_model_suffix}"
  prefix_lambda_temp     = "${local.datalake_s3_key_prefix}/year=9999/month=!{partitionKeyFromLambda:month}/day=!{partitionKeyFromLambda:day}/"
  prefix_lambda          = "${local.datalake_s3_key_prefix}/year=!{partitionKeyFromLambda:year}/month=!{partitionKeyFromLambda:month}/day=!{partitionKeyFromLambda:day}/"
  prefix_timestamp_temp  = "${local.datalake_s3_key_prefix}/year=9999/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  prefix_timestamp       = "${local.datalake_s3_key_prefix}/year=!{timestamp:yyyy}}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  prefix_partitioned     = var.s3_write_temp_year_partition ? (var.dynamic_partitioning_enabled ? local.prefix_lambda_temp : local.prefix_timestamp_temp) : (var.dynamic_partitioning_enabled ? local.prefix_lambda : local.prefix_timestamp)

  error_model_prefix               = "datalake-errors/${module.this.attributes[0]}${var.s3_model_suffix}"
  error_prefix                     = "${local.error_model_prefix}/result=!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  error_prefix_temp_year_partition = "${local.error_model_prefix}/result=!{firehose:error-output-type}/year=9999/month=!{timestamp:MM}/day=!{timestamp:dd}/"
}

module "kinesis_stream" {
  count = module.this.enabled ? 1 : 0

  source  = "justtrackio/kinesis/aws"
  version = "1.0.0"

  context      = module.this.context
  label_orders = var.label_orders

  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period
  alarm_create     = var.alarm_create

  alarm_read_bytes_high   = var.alarm_read_bytes_high
  alarm_iterator_age_high = var.alarm_iterator_age_high
  alarm_put_records       = var.alarm_put_records
}

resource "aws_cloudwatch_log_group" "main" {
  count = module.this.enabled ? 1 : 0

  name              = "/aws/kinesisfirehose/${module.this.id}"
  retention_in_days = var.log_group_retention_in_days

  tags = module.this.tags
}

resource "aws_cloudwatch_log_stream" "main" {
  count = module.this.enabled ? 1 : 0

  name           = "S3"
  log_group_name = aws_cloudwatch_log_group.main[0].name
}

resource "aws_kinesis_firehose_delivery_stream" "main" {
  count = module.this.enabled ? 1 : 0

  destination = "extended_s3"
  name        = module.this.id

  extended_s3_configuration {
    bucket_arn      = var.s3_bucket_arn
    role_arn        = aws_iam_role.firehose[0].arn
    buffer_size     = 128
    buffer_interval = var.buffer_interval

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = aws_cloudwatch_log_group.main[0].name
      log_stream_name = aws_cloudwatch_log_stream.main[0].name
    }

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {
            case_insensitive = true
          }
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {
            compression = "SNAPPY"
          }
        }
      }

      schema_configuration {
        database_name = var.glue_database_name
        role_arn      = aws_iam_role.firehose[0].arn
        table_name    = var.glue_table_name
      }
    }

    dynamic "dynamic_partitioning_configuration" {
      for_each = var.dynamic_partitioning_enabled ? [true] : []
      content {
        enabled = var.dynamic_partitioning_enabled
      }
    }

    dynamic "processing_configuration" {
      for_each = var.dynamic_partitioning_enabled ? [true] : []
      content {
        enabled = var.dynamic_partitioning_enabled

        processors {
          type = "Lambda"

          parameters {
            parameter_name  = "LambdaArn"
            parameter_value = "${var.dynamic_partitioning_lambda_transformer_function_arn}:$LATEST"
          }

          parameters {
            parameter_name  = "BufferSizeInMBs"
            parameter_value = var.dynamic_partitioning_lambda_buffer_size
          }
        }
      }
    }

    # dynamic partitions in error_output_prefix are not supported
    error_output_prefix = var.s3_write_temp_year_partition ? local.error_prefix_temp_year_partition : local.error_prefix
    prefix              = local.prefix_partitioned
  }

  kinesis_source_configuration {
    kinesis_stream_arn = module.kinesis_stream[0].kinesis_stream_arn
    role_arn           = aws_iam_role.firehose[0].arn
  }

  tags = module.this.tags
}
