# variable "ingress_rules" {
#     description = "List and Obeject of the description"
#     type = list(object({
#         from_port = number,
#         to_port = number,
#         cidr_blocks = list(string),
#         protocol = string,
# }))

#     default = [{
#         from_port = 80
#         to_port = 80
#         cidr_blocks = ["0.0.0.0/0"]
#         protocol = "tcp"
#     }, {
#         from_port = 443
#         to_port = 443
#         cidr_blocks = ["0.0.0.0/0"]
#         protocol = "tcp"
#     }]
# }

# variable "car_model" {

#     type = list(object ({
#     car = string,
#     brand = string,
#     year = number,
#     is_electric = bool
# }))

#     default = [{
#         car = "honda",
#         brand = "honda",
#         year = 2003,
#         is_electric = false
# }]
# }