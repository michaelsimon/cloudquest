resource "aws_autoscaling_group" "quest-asg" {
  name                      = "quest-asg"
  max_size                  = 1
  min_size                  = 0
  health_check_grace_period = 300
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = module.vpc.public_subnets[*]
  target_group_arns         = [aws_lb_target_group.quest-alb-tg.arn]
  launch_template {
    id      = aws_launch_template.quest-ec2-lt.id
    version = "$Latest"
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
