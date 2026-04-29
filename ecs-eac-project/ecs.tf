resource "aws_ecs_cluster" "main" {
 name = "raghu-eac-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
 name = "ecsTaskExecutionRole"

 assume_role_policy = jsonencode({
   Version="2012-10-17"
   Statement=[{
      Effect="Allow"
      Principal={Service="ecs-tasks.amazonaws.com"}
      Action="sts:AssumeRole"
   }]
 })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
 role       = aws_iam_role.ecs_task_execution_role.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app" {
 family = "nginx-app"
 requires_compatibilities = ["FARGATE"]
 network_mode = "awsvpc"
 cpu = 256
 memory = 512
 execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

 container_definitions = file("task-definition.json")
}

resource "aws_ecs_service" "app" {
 name = "web-service"
 cluster = aws_ecs_cluster.main.id
 task_definition = aws_ecs_task_definition.app.arn
 desired_count = 2
 launch_type = "FARGATE"

 network_configuration {
   subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]
   security_groups = [aws_security_group.ecs_sg.id]
   assign_public_ip = true
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.app.arn
   container_name = "nginx"
   container_port = 80
 }

 depends_on = [aws_lb_listener.http]
}
