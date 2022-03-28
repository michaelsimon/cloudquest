resource "aws_ecs_cluster" "quest-ecs-cluster" {
  name = "quest-ecs-cluster"
}

resource "aws_ecs_service" "quest-ecs-service" {
  name            = "quest-ecs-service"
  cluster         = aws_ecs_cluster.quest-ecs-cluster.id
  task_definition = aws_ecs_task_definition.quest-task-definition.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.quest-alb-tg.arn
    container_name   = "quest"
    container_port   = 3000
  }
}

resource "aws_ecs_cluster_capacity_providers" "quest-ecs-cap-provs" {
  cluster_name       = aws_ecs_cluster.quest-ecs-cluster.name
  capacity_providers = [aws_ecs_capacity_provider.quest-ecs-cap-prov.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.quest-ecs-cap-prov.name
  }
}

resource "aws_ecs_capacity_provider" "quest-ecs-cap-prov" {
  name = "quest"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.quest-asg.arn
    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
}

resource "aws_ecs_task_definition" "quest-task-definition" {
  family                   = "quest-family"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = 1024
  memory                   = 1024
  container_definitions = jsonencode([
    {
      name  = "quest"
      image = "${aws_ecr_repository.quest-ecr.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
        }
      ]
    }
  ])
  depends_on = [null_resource.docker_build]
}
