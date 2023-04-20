resource "aws_sns_topic_subscription" "kinesis_forwarder" {
  count = module.this.enabled && var.kinesis_forwarder_enabled ? 1 : 0

  protocol  = "lambda"
  endpoint  = var.kinesis_forwarder_lambda_function_arn
  topic_arn = var.kinesis_forwarder_source_arn

  endpoint_auto_confirms = true
}

resource "aws_lambda_permission" "sns" {
  count         = module.this.enabled && var.kinesis_forwarder_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.kinesis_forwarder_lambda_function_name
  principal     = "sns.amazonaws.com"
  statement_id  = "AllowSubscriptionToSNS"
  source_arn    = var.kinesis_forwarder_source_arn
}

data "aws_iam_policy_document" "kinesis_forwarder" {
  count = module.this.enabled && var.kinesis_forwarder_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [
      module.kinesis_stream[0].kinesis_stream_arn
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [var.kinesis_forwarder_lambda_function_arn]
  }
}

resource "aws_iam_policy" "kinesis_forwarder" {
  count = module.iam_label.enabled && var.kinesis_forwarder_enabled ? 1 : 0
  name  = var.kinesis_forwarder_lambda_function_name

  policy = data.aws_iam_policy_document.kinesis_forwarder[0].json

  tags = module.iam_label.tags
}

resource "aws_iam_role_policy_attachment" "kinesis_forwarder" {
  count      = module.this.enabled && var.kinesis_forwarder_enabled ? 1 : 0
  role       = var.kinesis_forwarder_lambda_function_name
  policy_arn = aws_iam_policy.kinesis_forwarder[0].arn
}

data "aws_iam_policy_document" "firehose_transformer" {
  count = module.this.enabled && var.dynamic_partitioning_enabled ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [var.dynamic_partitioning_lambda_transformer_function_arn]
  }
}

resource "aws_iam_policy" "firehose_transformer" {
  count = module.this.enabled && var.dynamic_partitioning_enabled ? 1 : 0
  name  = var.dynamic_partitioning_lambda_transformer_function_name

  policy = data.aws_iam_policy_document.firehose_transformer[0].json
}

resource "aws_iam_role_policy_attachment" "firehose_transformer" {
  count      = module.this.enabled && var.dynamic_partitioning_enabled ? 1 : 0
  role       = var.dynamic_partitioning_lambda_transformer_function_name
  policy_arn = aws_iam_policy.firehose_transformer[0].arn
}
