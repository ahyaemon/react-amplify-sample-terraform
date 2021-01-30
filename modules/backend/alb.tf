resource "aws_security_group" "backend_alb" {
  name        = "backend-alb"
  vpc_id      = aws_vpc.backend.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "backend-alb"
  }
}

resource "aws_lb" "backend" {
  name = "backend"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.backend_alb.id]
  subnets = [
    aws_subnet.public_backend1.id,
    aws_subnet.public_backend2.id,
  ]

  // TODO アクセスログ取る

}

resource "aws_lb_target_group" "backend" {
  name     = "backend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.backend.id
  target_type = "ip"
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
