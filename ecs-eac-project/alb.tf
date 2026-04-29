resource "aws_lb" "app" {
 name = "ecs-app-alb"
 load_balancer_type = "application"
 security_groups = [aws_security_group.alb_sg.id]
 subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_target_group" "app" {
 name = "app-tg"
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.main.id
 target_type = "ip"
}

resource "aws_lb_listener" "http" {
 load_balancer_arn = aws_lb.app.arn
 port = 80
 protocol = "HTTP"

 default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.app.arn
 }
}
