resource "aws_lb" "quest-alb" {
  name               = "quest-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.quest-sg-alb.id]
  subnets            = module.vpc.public_subnets[*]
}

resource "aws_lb_listener" "quest-alb-listener-443" {
  load_balancer_arn = aws_lb.quest-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest-alb-tg.arn
  }
}

resource "aws_lb_target_group" "quest-alb-tg" {
  name     = "quest-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
