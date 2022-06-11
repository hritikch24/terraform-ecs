## Application configurations
account      = 000000
region       = "eu-west-1"
app_name     = "ecs-demo"
env          = "dev"
app_services = ["webapp", "customer", "transaction"]

#VPC configurations
cidr               = "10.10.0.0/16"
availability_zones = ["eu-west-1a", "eu-west-1b"]
public_subnets     = ["10.10.50.0/24", "10.10.51.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

#Internal ALB configurations
internal_alb_config = {
  name      = "Internal-Alb"
  listeners = {
    "HTTP" = {
      listener_port     = 80
      listener_protocol = "HTTP"

    }
  }

  ingress_rules = [
    {
      from_port   = 55101
      to_port     = 55115
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["10.10.0.0/16"]
    }
  ]
}

#Friendly url name for internal load balancer DNS
internal_url_name = "service.dev"

#Public ALB configurations
public_alb_config = {
  name      = "Public-Alb"
  listeners = {
    "HTTP" = {
      listener_port     = 80
      listener_protocol = "HTTP"

    }
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

#Microservices
microservice_config = {
  "WebApp" = {
    name             = "WebApp"
    is_public        = true
    container_port   = 80
    host_port        = 80
    cpu              = 256
    memory           = 512
    desired_count    = 1
    alb_target_group = {
      port              = 80
      protocol          = "HTTP"
      path_pattern      = ["/*"]
      health_check_path = "/health"
      priority          = 1
    }
  },
  "Customer" = {
    name             = "Customer"
    is_public        = false
    container_port   = 3000
    host_port        = 3000
    cpu              = 256
    memory           = 512
    desired_count    = 1
    alb_target_group = {
      port              = 3000
      protocol          = "HTTP"
      path_pattern      = ["/customer*"]
      health_check_path = "/health"
      priority          = 1
    }
  }
}
