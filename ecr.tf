resource "aws_ecr_repository" "quest-ecr" {
  name                 = "quest-quest-repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "quest-ecr-policy" {
  repository = aws_ecr_repository.quest-ecr.name
  policy     = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

resource "null_resource" "docker_build" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
      export AWS_ACCESS_KEY_ID=${var.aws_access_key}
      export AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.quest-ecr.repository_url}
      docker build -t ${aws_ecr_repository.quest-ecr.name}:latest ./resources/quest
      docker tag ${aws_ecr_repository.quest-ecr.name}:latest ${aws_ecr_repository.quest-ecr.repository_url}:latest
      docker push ${aws_ecr_repository.quest-ecr.repository_url}:latest
      EOT
    }
}