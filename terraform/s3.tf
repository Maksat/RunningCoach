resource "aws_s3_bucket" "assets" {
  bucket = "runningcoach-assets-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
