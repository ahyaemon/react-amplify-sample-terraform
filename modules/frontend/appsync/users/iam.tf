resource "aws_iam_role" "appsync_arn" {
  name = "appsync_users_arn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "appsync_policy" {
  name = "appsync_users_policy"
  role = aws_iam_role.appsync_arn.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.users_table.arn}"
      ]
    }
  ]
}
EOF
}
