# Quest in the Clouds

Quest in the Clouds is an exercise in building out infrastructure in AWS to support a basic node js application running in a Docker Container. We are running this Docker container on an EC2 instance.

Terraform is leveraged to codify the infrastructure and performs the following operations:
* Creates VPC, subnets, and all required network components.
* Creates a private Elastic Container Registry to host the Docker image of the node JS application and pushes the binaries in this repo to ECR to create the image.
* Creates an ECS cluster, service, and task definition to run the Docker image on an AWS EC2-ECS Instance.
* Creates an EC2 launch template, autoscaling group, and application load balancer components to support the EC2 server-based hosting of the container.
* Creates necesssary IAM roles and policies for ECS and EC2.

## Requirements
### Tools
To deploy a copy of this application, you must have the following applications/utilities installed:
- [Terraform](https://www.terraform.io/downloads)
- [Docker Desktop](https://www.docker.com/get-started/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
Click the links for instrutions on setting up these tools.

### AWS Account
You must have an AWS Account with an IAM user that has CLI access to provision resources required by this application. You will need to provide your AWS Access Key/Secret Key Pair to utilize Terraform.

### Securely Load Balancing the Application
This application relies on an AWS Application Load Balancer (ALB) as a means to access the compute resources. The ALB also provides SSL encryption between the end user browser and the load balancer, and terminates SSL at the load balancer.

You will need to determine a DNS record to which you will point the application's load balancer. 
Subsequently, you will need to create an [AWS Certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html) with this domain name and provide the certificate ARN as part of installation.

## Installation

- Clone this repository

- Using a command line terminal, `cd` to the location of this cloned repo.
 
- Copy the `terraform.tfvars.template` file  to `terraform.tfvars`. Edit the file and provide your AWS Access Key and Secret Key.

- Run `terraform init` to download terraform resource dependencies.

- Request and validate an AWS Certificate. Provide the certificate ARN in the terraform.tfvars file as well.

- Run `terraform plan` to validate the resources that will be created.

- Run `terraform apply` to provision the resources in AWS. You will need to accept the proposed plan by entering "yes" when prompted.

- Allow time for resources to provision.

- Acquire the "A" record for the Application Load Balancer. In your DNS system, create a CNAME record from your desired domain address to the Application Load Balancer.

- Visit your domain address in a web browser to access the application (If you receive any 5xx errors, AWS is likely still provisioning the resources).

## Demo
A copy of this application can be seen at https://rearc.michaelsimon.co