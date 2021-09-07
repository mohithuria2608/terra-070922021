module "s3_bucket_alb_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"
  #bucket = "fcs-app1-cac1-${var.environment}-"
  bucket = "fcs-app1-cac1abcd1"
  acl    = "log-delivery-write"
  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
}