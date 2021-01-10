resource "aws_s3_bucket" "s3_bucket" {
  bucket = "ahyaemon-react-amplify-sample-frontend"
  acl    = "private"
}

data "aws_iam_policy_document" "cloudfront_access_policy_document" {
  version   = "2012-10-17"
  policy_id = "cloudfront_access"
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.iam_arn]
      type        = "AWS"
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "cloudfront_access_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_access_policy_document.json
}
