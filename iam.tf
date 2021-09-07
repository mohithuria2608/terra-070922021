resource "aws_iam_role" "grafana" {
  #resource "aws_iam_role" "grafana- ${var.environment}" {
  name_prefix = "FCS-APP1-CAC1-${var.environment}-"

  assume_role_policy = <<EOF
{
  "Version":  "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
         "AWS": "arn:aws:iam::779527285137:user/mohit.huria"     
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    name = "grafana-${var.environment}"
  }
}

#resource "aws_iam_instance_profile" "grafana-${var.environment}" {
resource "aws_iam_instance_profile" "grafana" {
  name_prefix = "FCS-APP1-CAC1-${var.environment}-"
  role        = aws_iam_role.grafana.name
}

#resource "aws_iam_policy" "grafana-${var.environment}" {
resource "aws_iam_policy" "grafana" {
  name_prefix = "FCS-APP1-CAC1-${var.environment}-"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingLogsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        }
    ]
}

EOF
}

data "aws_iam_policy" "CloudWatchReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

data "aws_iam_policy" "TimestreamReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
}

#data "aws_iam_policy" "grafanacw" {
#  arn = "arn:aws:iam::aws:policy/grafanacw"
#}

resource "aws_iam_role_policy_attachment" "CloudWatchReadOnlyAccess" {
  #role       = aws_iam_role.grafana-${var.environment}.name
  role       = aws_iam_role.grafana.name
  policy_arn = data.aws_iam_policy.CloudWatchReadOnlyAccess.arn
}

resource "aws_iam_role_policy_attachment" "TimestreamReadOnlyAccess" {
  #role       = aws_iam_role.grafana-${var.environment}.name
  role       = aws_iam_role.grafana.name
  policy_arn = data.aws_iam_policy.TimestreamReadOnlyAccess.arn
}

#resource "aws_iam_role_policy_attachment" "grafana-${var.environment}" {
resource "aws_iam_role_policy_attachment" "grafana" {
  #role       = aws_iam_role.grafana-${var.environment}.name
  role = aws_iam_role.grafana.name
  #policy_arn = aws_iam_policy.grafana-${var.environment}.arn
  policy_arn = aws_iam_policy.grafana.arn
}


## "AWS": "arn:aws:iam::779527285137:user/mohit.huria@bootlabstech.com"