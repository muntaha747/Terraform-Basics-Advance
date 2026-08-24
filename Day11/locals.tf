# locals {
#   all_instances_ids = aws_instance.ec2-instance[*].id
# }

locals {
  formatted_project_name = upper(replace(var.project_name, " ", "-"))
}

