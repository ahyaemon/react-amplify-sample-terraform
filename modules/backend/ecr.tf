resource "aws_ecr_repository" "repository" {
  name                 = "todo"
}

resource "aws_ecs_cluster" "backend" {
  name = "backend"
}

resource "aws_iam_role" "backend_task_execution" {
  name = "backend_task_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "backend_task_execution" {
  name        = "BackendECSTaskExecutionRolePolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  role = aws_iam_role.backend_task_execution.id
}

resource "aws_ecs_task_definition" "backend" {
  family                = "backend"
  container_definitions = file("${path.module}/task-definitions/backend.json")
  execution_role_arn = aws_iam_role.backend_task_execution.arn
  memory = 512
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
}

resource "aws_security_group" "backend_ecs" {
  name        = "backend-ecs"
  vpc_id      = aws_vpc.backend.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-ecs"
  }
}

resource "aws_ecs_service" "backend" {
  name = "backend"
  cluster = aws_ecs_cluster.backend.id
  desired_count = 1
  task_definition = aws_ecs_task_definition.backend.arn
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8080
  }

  network_configuration {
    subnets = [aws_subnet.public_backend1.id, aws_subnet.public_backend2.id]
    security_groups = [aws_security_group.backend_ecs.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_cloudwatch_log_group" "backenc-task" {
  name = "/ecs/backend-task"
}
