resource "aws_launch_template" "web_server_as" {
   
    image_id           = "ami-0454e52560c7f5c55"
    instance_type = "t2.micro"
    key_name = "project"
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb-240820"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-00bc90cea0de33da3", "subnet-0b5bd8d29282e7944"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1f", "us-east-1b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
  }

