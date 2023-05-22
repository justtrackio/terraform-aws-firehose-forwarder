module "example" {
  source = "../.."

  namespace   = "namespace"
  environment = "environment"
  stage       = "stage"
  name        = "kinesis"
  attributes  = ["foo"]

  alarm_enabled                          = false
  aws_account_id                         = "123456789012"
  glue_database_name                     = "db"
  glue_table_name                        = "table"
  kinesis_forwarder_lambda_function_arn  = "arn"
  kinesis_forwarder_lambda_function_name = "name"
  kinesis_forwarder_source_arn           = "arn:aws:sns:eu-central-1:123456789012:my-sns-topic"
  s3_bucket_arn                          = "arn:aws:s3:::my-fancy-bucket"
}
