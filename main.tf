# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"

}

# Create an IAM user
resource "aws_iam_user" "demo" {
  count = length(var.user_names)
  name  = element(var.user_names, count.index)
}

# Data source: IAM policy document
data "aws_iam_policy_document" "ec2_read_only" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

# Create an IAM policy
resource "aws_iam_policy" "ec2_read_only" {
  name   = "ec2-read-only"
  policy = data.aws_iam_policy_document.ec2_read_only.json
}

# Create an IAM user policy attachement
resource "aws_iam_user_policy_attachment" "ec2_access" {
  count      = length(var.user_names)
  user       = element(aws_iam_user.demo.*.name, count.index)
  policy_arn = aws_iam_policy.ec2_read_only.arn
}

# Data source: IAM policy document
data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:Describe*", "cloudwatch:Get*", "cloudwatch:List*"]
    resources = ["*"]
  }
}

# Create an IAM policy
resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

# Data source: IAM policy document
data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

# Create an IAM policy
resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

# Create an IAM user policy attachement
resource "aws_iam_user_policy_attachment" "neo_cloud_watch_full_access" {
  count = var.give_neo_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.demo.0.name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

# Create an IAM user policy attachement
resource "aws_iam_user_policy_attachment" "neo_cloud_watch_read_only" {
  count = var.give_neo_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.demo.0.name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
