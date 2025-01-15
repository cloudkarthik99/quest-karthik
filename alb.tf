resource "aws_acm_certificate" "alb_cert" {
  domain_name = "*.thetechvoyager.in"
  validation_method = "DNS"

  tags = {
    Name = "quest-alb-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb_sg" {
  name = "quest-alb-sg"
  description = "Security group for ALB"
  vpc_id = aws_vpc.quest_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
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

resource "aws_lb" "alb" {
  name = "quest-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = aws_subnet.public_subnet[*].id
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.alb_cert.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "quest-alb-target-group-http"
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.quest_vpc.id
  target_type = "ip"
}
