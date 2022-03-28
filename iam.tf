# # ecsInstanceRole
# resource "aws_iam_role" "quest-ecs-role" {
#   name = "quest-ecs-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "quest-ecs-attach" {
#   role       = aws_iam_role.quest-ecs-role.name
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
# }

# resource "aws_iam_service_linked_role" "AWSServiceRoleForECS" {
#   aws_service_name = "ecs.amazonaws.com"
#   custom_suffix ="rearc"
# }

resource "aws_iam_role" "quest-ecs_ec2-role" {
  name = "quest-ecs_ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "quest-ecs_ec2-role-policy" {
  name = "quest-ecs_ec2-role"
  role = aws_iam_role.quest-ecs_ec2-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "ec2:DescribeTags",
          "ecs:CreateCluster",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "quest-ecs_ec2-profile" {
  name = "quest-ecs_ec2-profile"
  role = aws_iam_role.quest-ecs_ec2-role.name
}