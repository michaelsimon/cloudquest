resource "aws_security_group" "quest-sg-alb" {
  name        = "allow_traffic_alb"
  description = "Allow inbound traffic to ALB"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Inbound from Public to ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "quest-sg-ec2" {
  name        = "allow_traffic_ec2"
  description = "Allow inbound traffic from ALB to EC2"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description     = "Inbound HTTP"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.quest-sg-alb.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
