resource "aws_instance" "example" {
  ami           = var.ami-image
  instance_type = var.ec2-types[1]
  region        = tolist(var.allowed_regions)[0]
  tags          = var.tags
  lifecycle {
    #create_before_destroy = false #first it will destroy than create new resources
    create_before_destroy = true # It will create resources first than destroy
    prevent_destroy       = false
  }
}



#########################################################
# AutoScaling Group [Lifeecycle ignore_changes]
#########################################################
resource "aws_autoscaling_group" "app_servers" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1
  health_check_type  = "EC2"
  availability_zones = var.availability_zones

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  launch_template {
    id      = aws_launch_template.app_servers.id
    version = "$Latest"
  }
  #We have referred this launch template map from below and created under autoscaling group resource.
}
#########################################################
# Launch template resource
#########################################################

resource "aws_launch_template" "app_servers" {
  name_prefix   = "app-servers"
  image_id      = var.ami-image
  instance_type = var.ec2-types[1]
}

#########################################################
# AWS Security Group
#########################################################

resource "aws_security_group" "aws-firewalls" {
  name        = "app-security-group"
  description = "We are creating a security group for Ec2 Machines"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow from anywhere on the internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow from anywhere on the internet"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow from anywhere on the internet"
  }
  tags = var.tags
}

# Ec2 Instance that gets replaced when the security group changes

resource "aws_instance" "app_with_sg" {
  ami                    = var.ami-image
  instance_type          = var.ec2-types[1]
  vpc_security_group_ids = [aws_security_group.aws-firewalls.id]
  tags                   = var.tags

  lifecycle {
    replace_triggered_by = [aws_security_group.aws-firewalls.id]
  }
}


#########################################################
# Post Condition on S3 Bucket resource
#########################################################

resource "aws_s3_bucket" "compliance-bucket" {
  bucket = "${var.buck-name}-compliance-bucket"

  lifecycle {
    postcondition {
      condition     = contains(keys(var.tags), "compliance")
      error_message = "ERROR: Bucket must have the compliance tag for auditing purpose"
    }
  }
}
