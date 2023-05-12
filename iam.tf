module "iam_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context     = module.this.context
  label_order = var.label_orders.iam
}

data "aws_iam_policy_document" "firehose_assume_role_policy" {
  count = module.iam_label.enabled ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [module.this.aws_account_id]
    }
  }
}

resource "aws_iam_role" "firehose" {
  count = module.iam_label.enabled ? 1 : 0

  name               = "${module.iam_label.id}-firehose"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_policy[0].json

  tags = module.iam_label.tags
}

data "aws_iam_policy_document" "firehose_policy" {
  count = module.iam_label.enabled ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["glue:GetTableVersions"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*",
      "${var.s3_bucket_arn}/datalake/${module.this.attributes[0]}${var.s3_model_suffix}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.main[0].arn}:log-stream:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords"
    ]
    resources = [
      module.kinesis_stream[0].kinesis_stream_arn
    ]
  }

  dynamic "statement" {
    for_each = var.dynamic_partitioning_enabled ? [true] : []
    content {
      effect = "Allow"
      actions = [
        "lambda:InvokeFunction"
      ]
      resources = [
        "${var.dynamic_partitioning_lambda_transformer_function_arn}:*"
      ]
    }
  }
}

resource "aws_iam_policy" "firehose" {
  count = module.iam_label.enabled ? 1 : 0

  name = "${module.iam_label.id}-firehose"

  policy = data.aws_iam_policy_document.firehose_policy[0].json

  tags = module.iam_label.tags
}

resource "aws_iam_role_policy_attachment" "main" {
  count = module.iam_label.enabled ? 1 : 0

  policy_arn = aws_iam_policy.firehose[0].arn
  role       = aws_iam_role.firehose[0].name
}
