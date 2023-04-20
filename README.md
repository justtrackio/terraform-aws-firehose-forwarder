# terraform-aws-firehose-forwarder
Terraform module which creates a kinesis stream and a lambda function (with access to the stream) triggered by an sns topic subscription

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_label"></a> [iam\_label](#module\_iam\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_kinesis_stream"></a> [kinesis\_stream](#module\_kinesis\_stream) | justtrackio/kinesis/aws | 1.0.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_policy.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.firehose_transformer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kinesis_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose_transformer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kinesis_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_firehose_delivery_stream.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_lambda_permission.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic_subscription.kinesis_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.firehose_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_transformer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kinesis_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alarm_create"></a> [alarm\_create](#input\_alarm\_create) | Whether or not to create alarms | `bool` | `false` | no |
| <a name="input_alarm_iterator_age_high"></a> [alarm\_iterator\_age\_high](#input\_alarm\_iterator\_age\_high) | Settings for the iterator age high alarm | <pre>object({<br>    create              = optional(bool, true)<br>    period              = optional(number, 60)<br>    evaluation_periods  = optional(number, 15)<br>    alarm_description   = optional(string, "This metric monitors kinesis iterator age")<br>    datapoints_to_alarm = optional(number, 10)<br>    threshold_seconds   = optional(number, 60)<br>  })</pre> | <pre>{<br>  "alarm_description": "This metric monitors kinesis iterator age",<br>  "create": true,<br>  "datapoints_to_alarm": 10,<br>  "evaluation_periods": 15,<br>  "period": 60,<br>  "threshold_seconds": 60<br>}</pre> | no |
| <a name="input_alarm_put_records"></a> [alarm\_put\_records](#input\_alarm\_put\_records) | Settings for the put records alarm | <pre>object({<br>    create               = optional(bool, true)<br>    period               = optional(number, 60)<br>    evaluation_periods   = optional(number, 15)<br>    alarm_description    = optional(string, "This metric monitors kinesis put records successful records (percent)")<br>    datapoints_to_alarm  = optional(number, 10)<br>    threshold_percentage = optional(number, 99)<br>  })</pre> | <pre>{<br>  "alarm_description": "This metric monitors kinesis put records successful records (percent)",<br>  "create": true,<br>  "datapoints_to_alarm": 10,<br>  "evaluation_periods": 15,<br>  "period": 60,<br>  "threshold_percentage": 99<br>}</pre> | no |
| <a name="input_alarm_read_bytes_high"></a> [alarm\_read\_bytes\_high](#input\_alarm\_read\_bytes\_high) | Settings for the read bytes high alarm | <pre>object({<br>    create               = optional(bool, true)<br>    period               = optional(number, 60)<br>    evaluation_periods   = optional(number, 15)<br>    alarm_description    = optional(string, "This metric monitors kinesis read bytes utilization")<br>    datapoints_to_alarm  = optional(number, 10)<br>    threshold_percentage = optional(number, 80)<br>  })</pre> | <pre>{<br>  "alarm_description": "This metric monitors kinesis read bytes utilization",<br>  "create": true,<br>  "datapoints_to_alarm": 10,<br>  "evaluation_periods": 15,<br>  "period": 60,<br>  "threshold_percentage": 80<br>}</pre> | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_buffer_interval"></a> [buffer\_interval](#input\_buffer\_interval) | (Optional) Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. The default value is 300. | `number` | `300` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_dynamic_partitioning_enabled"></a> [dynamic\_partitioning\_enabled](#input\_dynamic\_partitioning\_enabled) | Whether or not to use dynamic partitioning | `bool` | `false` | no |
| <a name="input_dynamic_partitioning_lambda_transformer_function_arn"></a> [dynamic\_partitioning\_lambda\_transformer\_function\_arn](#input\_dynamic\_partitioning\_lambda\_transformer\_function\_arn) | ARN of the Lambda function to transform the data for dynamic partitioning | `string` | `null` | no |
| <a name="input_dynamic_partitioning_lambda_transformer_function_name"></a> [dynamic\_partitioning\_lambda\_transformer\_function\_name](#input\_dynamic\_partitioning\_lambda\_transformer\_function\_name) | Name of the Lambda function to transform the data for dynamic partitioning | `string` | `null` | no |
| <a name="input_dynamic_partitioning_processor_parameters"></a> [dynamic\_partitioning\_processor\_parameters](#input\_dynamic\_partitioning\_processor\_parameters) | Set of parameter for the dynamic partitioning processor | <pre>set(object({<br>    parameter_name  = string<br>    parameter_value = any<br>  }))</pre> | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_glue_database_name"></a> [glue\_database\_name](#input\_glue\_database\_name) | Name of the Glue database to be used for your schema configuration | `string` | n/a | yes |
| <a name="input_glue_table_name"></a> [glue\_table\_name](#input\_glue\_table\_name) | Name of the Glue table to be used for your schema configuration | `string` | n/a | yes |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_kinesis_forwarder_enabled"></a> [kinesis\_forwarder\_enabled](#input\_kinesis\_forwarder\_enabled) | Whether to subscribe to an sns topic to allow a kinesis forwarder lambda to put data into the stream | `bool` | `true` | no |
| <a name="input_kinesis_forwarder_lambda_function_arn"></a> [kinesis\_forwarder\_lambda\_function\_arn](#input\_kinesis\_forwarder\_lambda\_function\_arn) | ARN of the Lambda function to be used to forward data to the firehose stream | `string` | `null` | no |
| <a name="input_kinesis_forwarder_lambda_function_name"></a> [kinesis\_forwarder\_lambda\_function\_name](#input\_kinesis\_forwarder\_lambda\_function\_name) | Name of the Lambda function to be used to forward data to the firehose stream | `string` | `null` | no |
| <a name="input_kinesis_forwarder_source_arn"></a> [kinesis\_forwarder\_source\_arn](#input\_kinesis\_forwarder\_source\_arn) | ARN of the SNS topic to be used as data source by your lambda function | `string` | `null` | no |
| <a name="input_kinesis_retention_period"></a> [kinesis\_retention\_period](#input\_kinesis\_retention\_period) | How many hours to keep data of the stream | `number` | `24` | no |
| <a name="input_kinesis_shard_count"></a> [kinesis\_shard\_count](#input\_kinesis\_shard\_count) | How many shards to create for the input kinesis data stream | `number` | `1` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_orders"></a> [label\_orders](#input\_label\_orders) | Overrides the `labels_order` for the different labels to modify ID elements appear in the `id` | <pre>object({<br>    cloudwatch = optional(list(string)),<br>    iam        = optional(list(string)),<br>    kinesis    = optional(list(string)),<br>  })</pre> | `{}` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Defaults to 30 Days. | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | ARN of the S3 Bucket to put the kinesis datastream data into | `string` | n/a | yes |
| <a name="input_s3_model_suffix"></a> [s3\_model\_suffix](#input\_s3\_model\_suffix) | Suffix to use for datalake key | `string` | `""` | no |
| <a name="input_s3_write_temp_year_partition"></a> [s3\_write\_temp\_year\_partition](#input\_s3\_write\_temp\_year\_partition) | Whether or not to write data to a temporary Year 9999 partition | `bool` | `false` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kinesis_firehose_delivery_stream_arn"></a> [kinesis\_firehose\_delivery\_stream\_arn](#output\_kinesis\_firehose\_delivery\_stream\_arn) | ARN for the created kinesis firehose delivery stream |
| <a name="output_kinesis_stream_arn"></a> [kinesis\_stream\_arn](#output\_kinesis\_stream\_arn) | ARN for the created kinesis stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
