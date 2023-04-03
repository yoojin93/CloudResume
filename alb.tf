resource "aws_lb" "web-alb" {
  name                       = "web-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  enable_deletion_protection = false

  tags = {
    Name = "web-alb"
  }
}

resource "aws_lb_target_group" "web-alb-target" {
  name     = "web-alb-target"
  port     = 80
  protocol = "HTTP"
  stickiness {
    type = "lb_cookie"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-alb-target.arn
  }
}