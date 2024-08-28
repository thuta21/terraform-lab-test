# Output variable: ARN
output "neo_arn" {
  value = [
    # ["${aws_iam_user.demo.*.arn}"],
    # ["${aws_iam_policy.ec2_read_only.arn}"],
    # ["${aws_iam_user_policy_attachment.ec2_access}"],
    # ["${aws_iam_user_policy_attachment.neo_cloud_watch_full_access}"],
    ["${aws_iam_user_policy_attachment.neo_cloud_watch_read_only}"],
  ]
}

