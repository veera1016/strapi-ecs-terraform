# ecs.tf
resource "aws_ecs_cluster" "main" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "veera1016/strapi:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "strapi"
    container_port   = 1337
  }
}
