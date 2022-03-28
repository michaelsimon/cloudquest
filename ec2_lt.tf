data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "quest-ec2-lt" {
  name = "quest-ec2-lt"
  iam_instance_profile {
    name = aws_iam_instance_profile.quest-ecs_ec2-profile.name
  }
  image_id      = data.aws_ami.aws-linux.id
  instance_type = "t2.medium"
  user_data     = filebase64("${abspath(path.module)}/resources/quest-lt-userdata.sh")
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.quest-sg-ec2.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ECS Cluster Host"
    }
  }
}
