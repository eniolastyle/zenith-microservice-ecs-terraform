# zenith-microservice-ecs-terraform-checkov

## Introduction

This repository contains Terraform code to deploy a solution that showcases the use of AWS resources for building a scalable and secure microservice architecture on Amazon ECS. The code demonstrates the implementation of DevOps practices and leverages Terraform and Checkov for infrastructure provisioning and security checks.

## Table of Contents

- [Solution Overview](#solution-overview)
- [General Information](#general-information)
- [Infrastructure](#infrastructure)
- [Application Code](#application-code)
- [Usage](#usage)
- [Checkov](#static-analysis-with-checkov)
- [Security](#security)
- [License](#license)

## Solution Overview

This repository provides a sample solution that illustrates the deployment of a microservice architecture using Amazon ECS. The solution incorporates various DevOps practices, including infrastructure as code, continuous integration and delivery (CI/CD), and security checks. By leveraging AWS services, the solution aims to minimize defects during deployments, facilitate remediation, mitigate deployment risks, and improve the flow into production environments.

## General Information

The project is divided into two main parts:

- **Code**: Contains the code for the running application, which includes the client and server components.
- **Infrastructure**: Contains the Terraform code responsible for deploying the necessary AWS resources for the solution.

## Infrastructure

The Infrastructure folder contains the Terraform code required to provision AWS resources. The Modules folder houses reusable Terraform modules, while the Templates folder contains configuration files used within the modules. By default, the Terraform state is stored locally on the machine where the commands are executed. However, you have the option to configure a Terraform backend such as an AWS S3 bucket or Terraform Cloud for remote state storage. The Terraform code in this repository deploys the following AWS resources:

- AWS networking resources following high availability (HA) best practices
- 2 Elastic Container Registry (ECR) repositories
- 1 ECS cluster
- 2 ECS services
- 2 task definitions
- 4 autoscaling policies with CloudWatch alarms
- 2 Application Load Balancers (ALBs) for public access
- IAM roles and policies for ECS tasks, CodeBuild, CodeDeploy, and CodePipeline
- Security groups for ALBs and ECS tasks
- 2 CodeBuild projects
- 2 CodeDeploy applications
- 1 CodePipeline pipeline
- 2 S3 buckets (one for CodePipeline artifacts and another for assets accessible within the application)
- 1 DynamoDB table (used by the application)
- 1 SNS topic for notifications

### Infrastructure Architecture

The following diagram represents the architecture of the deployed infrastructure:

![Infrastructure Architecture](Documentation_assets/Infrastructure_architecture.png)

### Infrastructure Considerations

The task definition template (`Infrastructure/Templates/taskdef.json`) used to enable Blue/Green deployments in ECS has hardcoded values for the memory and CPU settings of the server and client applications. If desired, you can modify these values dynamically using commands like `sed` in CodeBuild.

To receive notifications about the status of each completed CodeDeploy deployment, consider subscribing to the SNS topic created by this code.

## Application Code

### Client App

The Client folder contains the code for the frontend application, which is built with Vue.js. In the deployed version, the application uses port 80, but when running locally, it uses port 3000. The folder structure includes components, views, services, router, and assets.

#### Client Considerations

To ensure a seamless demo experience, follow these considerations:

1. The client application retrieves assets from the S3 bucket created by this code. Add three images to the S3 bucket.
2. The client application expects a DynamoDB structure with the following attributes:

   - `id` (Number, primary

 key)
   - `path` (String)
   - `title` (String)

   Add three DynamoDB items with the specified structure, where `path` corresponds to the S3 object URL for each added asset.

#### Server App

The Server folder contains the code for the backend application, which is built with Node.js. Similar to the client application, the deployed version uses port 80, while the local version uses port 3001. The server exposes three endpoints:

- `/status`: A dummy endpoint to check if the server is running (used for health checks).
- `/api/getAllProducts`: The main endpoint that returns all items from an AWS DynamoDB table.
- `/api/docs`: The Swagger endpoint for API documentation.

A Swagger endpoint is implemented to document the APIs. You can access it through the provided Terraform output link.

## Static Analysis with Checkov
To run static analysis on the Terraform code in this repository using Checkov, follow these steps:

Install Checkov by running the following command: `pip install checkov`
Run Checkov on the Terraform code by running the following command: `checkov --directory <path-to-code>`
View the results of the check either on the terminal or from the UI.
For more information on Checkov, see github.com.

## Usage

Follow the steps below to launch the infrastructure resources:

1. Fork this repository and create a GitHub token that grants access to the forked repository in your account.
2. Clone the forked repository from your account (not the one from the aws-sample organization) and navigate to the appropriate directory:

   ```bash
   cd Infrastructure/
   ```

3. Run `terraform init` to download the necessary providers and install the modules.
4. Run `terraform plan` to review the execution plan. You can specify variables using a `.tfvars` file or pass them directly as command-line arguments. The required variables include:
   - `aws_profile`: The name of the AWS profile in `~/.aws/credentials`.
   - `aws_region`: The AWS region in which to create the resources.
   - `environment_name`: A unique name used for resource naming conventions.
   - `github_token`: Your personal GitHub token generated in a previous step.
   - `repository_name`: The name of your GitHub repository.
   - `repository_owner`: The owner of the GitHub repository.

   Example command:

   ```shell
   terraform plan -var aws_profile="your-profile" -var aws_region="your-region" -var environment_name="your-env" -var github_token="your-personal-token" -var repository_name="your-github-repository" -var repository_owner="the-github-repository-owner"
   ```

5. Review the execution plan and verify the changes that Terraform will apply.
6. Run `terraform apply` to deploy the resources. Use the same variable values as in the previous step.
7. Once Terraform finishes deployment, go to the AWS Management Console, navigate to the AWS CodePipeline service, and check the status of the pipeline created by this Terraform code. Follow the steps mentioned in the [Client Considerations](#client-considerations) section to add files and DynamoDB items. After the pipeline successfully completes and the required assets are added, copy the `application_url` value from the Terraform output and open it in a browser.
8. To access the implemented Swagger endpoint, copy the `swagger_endpoint` value from the Terraform output and open it in a browser.

## Security

For information about security issue notifications, refer to the [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) file.

## License

This repository is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file for more details.
