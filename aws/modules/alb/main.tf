module "alb" {
  security_group_id = var.security_group_id
  vpc_id = var.vpc_id
  public_subnet_list = var.public_subnet_list
  environment  = var.environment
  private_subnet_list = var.private_subnet_list

}

resource "aws_lb" "my-web" {
  name               = "${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_id
  subnets            = var.public_subnet_list
  tags = {
    env = "var.environment"
  }
}


resource "aws_lb_target_group" "my-web-tg" {
  name        = "${var.environment}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}


resource "aws_lb_listener" "my-web-listener" {
  load_balancer_arn = aws_lb.my-web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-web-tg.arn
  }
}