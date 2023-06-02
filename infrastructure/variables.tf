variable "aws_profile" {
  description = "The profile name that you have configured in the file .aws/credentials"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The AWS Region in which you want to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "The name of your environment"
  type        = string

  validation {
    condition     = length(var.environment_name) < 23
    error_message = "Due the this variable is used for concatenation of names of other resources, the value must have less than 23 characters."
  }

  default = "zenith"
}

variable "github_token" {
  description = "Personal access token from Github"
  type        = string
  sensitive   = true
  default     = "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"
}

variable "port_app_server" {
  description = "The port used by your server application"
  type        = number
  default     = 3001
}

variable "port_app_client" {
  description = "The port used by your client application"
  type        = number
  default     = 80
}

variable "buildspec_path" {
  description = "The location of the buildspec file"
  type        = string
  default     = "./infrastructure/templates/buildspec.yaml"
}

variable "folder_path_server" {
  description = "The location of the server files"
  type        = string
  default     = "./webapp/server/."
}

variable "folder_path_client" {
  description = "The location of the client files"
  type        = string
  default     = "./webapp/client/."
}

variable "container_name" {
  description = "The name of the container of each ECS service"
  type        = map(string)
  default = {
    server = "Container-server"
    client = "Container-client"
  }
}

variable "iam_role_name" {
  description = "The name of the IAM Role for each service"
  type        = map(string)
  default = {
    devops        = "DevOps-Role"
    ecs           = "ECS-task-excecution-Role"
    ecs_task_role = "ECS-task-Role"
    codedeploy    = "CodeDeploy-Role"
  }
}

variable "repository_owner" {
  description = "The name of the owner of the Github repository"
  type        = string
  default     = "eniolastyle"
}

variable "repository_name" {
  description = "The name of the Github repository"
  type        = string
  default     = "zenith-microservice-ecs-terraform"
}

variable "repository_branch" {
  description = "The name of branch the Github repository, which is going to trigger a new CodePipeline excecution"
  type        = string
  default     = "main"
}
