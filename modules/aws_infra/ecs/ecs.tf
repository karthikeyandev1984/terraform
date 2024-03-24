module "ecs" {
  security_group_id = var.security_group_id
  vpc_id = var.vpc_id
  public_subnet_list = var.public_subnet_list
  private_subnet_list = var.private_subnet_list
  environment  = var.environment
}


resource "aws_ecs_cluster" "my-web-cluster" {
  name = "${var.environment}-ecs"
}

resource "aws_ecs_cluster_capacity_providers" "my-web-cluster" {
  cluster_name = aws_ecs_cluster.my-web-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}


resource "aws_ecs_task_definition" "my-web" {
  family                   = "service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "my-web-api"
      image     = "nginx:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}



resource "aws_ecs_service" "my-web-service" {
  name            = "my-web-service"
  cluster         = aws_ecs_cluster.my-web-cluster.id
  task_definition = aws_ecs_task_definition.my-web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_list
    security_groups  = aws_security_group.ecs_tasks.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = "my-web-api"
    container_port   = 80
  }

}


resource "aws_security_group" "ecs_tasks" {
  name        = "myapp-ecs-tasks-security-group"
  description = "allow inbound access"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
