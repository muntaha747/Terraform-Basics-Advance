locals {
  all_instances_ids = aws_instance.ec2-instance[*].id
}

