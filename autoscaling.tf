#Launch Configuration

resource "aws_launch_configuration" "grafana" {
  # name_prefix                 = "FCS-APP1-CAC1-${var.environment}-"
  name_prefix     = "FCS-B-${var.environment}"
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [module.security_group_ec2.security_group_id]
  #iam_instance_profile        = aws_iam_instance_profile.grafana-${var.environment}.name
  iam_instance_profile        = aws_iam_instance_profile.grafana.name
  associate_public_ip_address = "false"

  lifecycle {
    create_before_destroy = true
  }
}

#Creating Autoscaling Group
resource "aws_autoscaling_group" "grafana" {
  #name_prefix                 = "FCS-APP1-CAC1-${var.environment} "
  launch_configuration = aws_launch_configuration.grafana.name
  vpc_zone_identifier  = data.aws_subnet_ids.all.ids
  min_size             = 1
  desired_capacity     = 2
  max_size             = 2
  health_check_type    = "EC2"
  # load_balancers = [aws_alb.alb.id]
  target_group_arns = [aws_alb_target_group.grafana.arn]
}

#Target Group creation
resource "aws_alb_target_group" "grafana" {
  #count = length(aws_instance.instance)
  #name_prefix                 = "FCS-APP1-CAC1-${var.environment}-"
  #name_prefix = "FCS-1 ${var.environment}" 
  port     = 443
  protocol = "HTTPS"
  vpc_id   = data.aws_vpc.default.id
  stickiness {
    type = "lb_cookie"
  }
  tags = {
    Environment = var.environment
    Customer    = var.customer
    Application = var.application
    name        = "FCS-1"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path                = "/api/health"
    protocol            = "HTTPS"
    port                = 443
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}


#Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "target-group" {
  #count                       = length(aws_instance.instance)
  count            = length(module.ec2_instance)
  target_group_arn = aws_alb_target_group.grafana.arn
  #target_id        = aws_instance.instance.id
  #target_id                   = aws_instance.instance[count.index].id
  #target_id                   = module.ec2_instance[count.index].id
  target_id = module.ec2_instance.id
  port      = 443
}



