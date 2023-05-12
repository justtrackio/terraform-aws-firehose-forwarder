output "kinesis_firehose_delivery_stream_arn" {
  value       = try(aws_kinesis_firehose_delivery_stream.main[0].arn, "")
  description = "ARN for the created kinesis firehose delivery stream"
}

output "kinesis_stream_arn" {
  value       = try(module.kinesis_stream[0].kinesis_stream_arn, "")
  description = "ARN for the created kinesis stream"
}
