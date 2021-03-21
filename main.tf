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
  length  = 4
  special = false
}
resource "random_string" "random2" {
  length  = 4
  special = false
}
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}
resource "docker_container" "nodered_container1" {
  name  = join("-", ["nodered", random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 8080
  }
}
resource "docker_container" "nodered_container2" {
  name  = join("-", ["nodered", random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 8080
  }
}
output "container1ip" {
  #  value       = docker_container.nodered_image.ip_address
  value       = join(":", [docker_container.nodered_container1.ip_address, docker_container.nodered_container1.ports[0].internal])
  description = "dispalying the ipadess of the container"
}
output "Container1_Name" {
  value       = docker_container.nodered_container1.name
  description = "displaying image name"
}
output "Container2IPADDRESSport" {
  #  value       = docker_container.nodered_image.ip_address
  value       = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].internal])
  description = "dispalying the ipadess of the container"
}
output "Container2_Name" {
  value       = docker_container.nodered_container2.name
  description = "displaying image name"
}
