terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.31.0"
    }
  }
}

# download nodered image

provider "docker" {}
resource "random_string" "random" {
  count   = 1
  length  = 5
  special = false
}
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}
resource "docker_container" "nodered_container1" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 8080
  }
}
#output "container1ip" {
#  #  value       = docker_container.nodered_image.ip_address
#  value       = join(":", [join(",", docker_container.nodered_container1[*].ip_address), docker_container.nodered_container1[*].ports[0].internal])
#  description = "dispalying the ipadess of the container"
#}
#output "Container1_Name" {
#  value       = docker_container.nodered_container1[0].name
#  description = "displaying image name"
#}
#output "Container2IPADDRESSport" {
#  #  value       = docker_container.nodered_image.ip_address
#  value       = join(":", [docker_container.nodered_container1[1].ip_address, docker_container.nodered_container1[1].ports[0].internal])
#  description = "dispalying the ipadess of the container"
#}
#output "Container2_Name" {
#  value       = docker_container.nodered_container1[1].name
#  description = "displaying image name"
#}
output "containeraccesspoints" {
  value       = [for i in docker_container.nodered_container1[*] : join(":", [chomp(data.http.myip.body)], i.ports[*]["external"])]
  description = "Container ip address"
}
output "containername" {
  value = [for i in docker_container.nodered_container1[*] : i.name]
}
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

