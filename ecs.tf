resource "aws_security_group" "ecs_security_group" {
  name = "quest-ecs-sg"
  description = "Security group for ECS"
  vpc_id = aws_vpc.quest_vpc.id

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "quest-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "quest-family"
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu = "256"
  memory = "256"

  container_definitions = jsonencode ([
    {
      name = "quest-app"
      image = "183295421798.dkr.ecr.us-east-1.amazonaws.com/quest:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort = 3000
          protocol = "tcp"
        }
      ]
      environment = [
        {
          name = "SECRET_WORD"
          value = "TwelveFactor"
        }
      ]
    } 
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name = "quest-ecs-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 1
  force_new_deployment = true
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets = [aws_subnet.private_subnet.id]
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name = "quest-app"
    container_port = 3000
  }

  depends_on = [aws_lb_listener.alb_http_listener, aws_lb_listener.alb_https_listener]
}

resource "aws_launch_template" "ecs_launch_template" {
  name_prefix = "quest-ecs-launch-template"
  image_id = data.aws_ami.ecs_ami.id
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
              EOF
  )
  vpc_security_group_ids = [aws_security_group.ecs_security_group.id]
  key_name = "quest-ssh"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
}

resource "aws_autoscaling_group" "ecs-aws_autoscaling_group" {
  name = "quest-ecs-autoscaling-group"
  vpc_zone_identifier = [aws_subnet.private_subnet.id]
  desired_capacity = 1
  max_size = 1
  min_size = 1

  launch_template {
    id = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key = "AmazonECSManaged"
    value = true
    propagate_at_launch = true
  }
}