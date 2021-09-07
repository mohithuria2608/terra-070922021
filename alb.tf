module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  #name_prefix          = "FCS-APP1-CAC1-${var.environment}-"
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.default.id
  #subnet_id            = data.aws_subnet_ids.all.ids
  subnets = data.aws_subnet_ids.all.ids
  security_groups = [module.security_group_alb.security_group_id]
  access_logs = {
    #bucket             = module.s3_bucket_alb_logs_s3_bucket_id
    bucket = var.s3_bucket
  }

  target_groups = [
    {
      #name_prefix      = "FCS-APP1-CAC1-${var.environment}-"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      targets = [
        {
          #target_id    = module.ec2_instance.ec2_instance_id
          target_id = module.ec2_instance.id
          port      = 80
        },
        {
          #target_id    = module.ec2_instance.ec2_instance_id
          target_id = module.ec2_instance.id
          port      = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::779527285137:server-certificate/test_cert-779527285137"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    environment = var.environment
    #Environment = var.environment
    name = "FCS-APP1-CAC1-${var.environment}-"
  }


}
