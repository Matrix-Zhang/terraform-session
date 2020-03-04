provider "template" {
  version = "~> 2.1"
}

data "template_file" "user_script" {
  template = file("${path.module}/user-script.sh")

  vars = {
    db_address  = local.mysql_config.address
    db_port     = local.mysql_config.port
    server_port = var.server_port
  }
}

module "alb" {
  source     = "../../../modules/networking/alb/"
  alb_name   = "hello-world-${var.environment}"
  subnet_ids = local.subnet_ids
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "hello-world-${var.environment}"
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = data.template_file.user_script.rendered

  max_size           = var.max_size
  min_size           = var.min_size
  enable_autoscaling = var.enable_autoscaling

  subnet_ids        = local.subnet_ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  custom_tags       = var.custom_tags
}

resource "aws_lb_target_group" "asg" {
  name     = "hello-world-${var.environment}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = 200
    timeout             = 5
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
