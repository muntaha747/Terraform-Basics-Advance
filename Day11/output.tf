# ##############################################################################################################################################################################################
# #Output
# ##############################################################################################################################################################################################
# output "vpc_id" {
#   value = aws_vpc.my-vpc.id

# }

# output "ec2_id" {

#   value = aws_instance.ec2-instance[*].id # --> Because we are using the conditionals  and count arguement in the Ec2 Resource thats why we are using [*]. Star means all the ID's.
# }


output "instances_id" {
  value = local.all_instances_ids
}

output "formatted_project_name" {
  value = local.formatted_project_name
}

