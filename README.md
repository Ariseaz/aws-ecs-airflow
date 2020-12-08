# airflow-ecs
Setup to run Airflow in AWS ECS containers

## Requirements

### Local
* Docker

### AWS
* AWS IAM User for the infrastructure deployment, with admin permissions
* [awscli](https://aws.amazon.com/cli/), intall running `pip install awscli`
* [terraform >= 0.13](https://www.terraform.io/downloads.html)
* setup your IAM User credentials inside `~/.aws/credentials`
* setup these env variables in your .zshrc or .bashrc, or in your the terminal session that you are going to use
  <pre>
  export AWS_ACCOUNT=your_account_id
  export AWS_DEFAULT_REGION=us-east-1 # it's the default region that needs to be setup also in infrastructure/config.tf
  </pre>


## Local Development
* Generate a Fernet Key:
  <pre>
  pip install cryptography
  export AIRFLOW_FERNET_KEY=$(python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")

  or

  export AIRFLOW_FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
  </pre>
  

* Start Airflow locally simply running:
  <pre>
  docker-compose up --build
  </pre

If everything runs correctly you can reach Airflow navigating to [localhost:8080](http://localhost:8080).
The current setup is based on [Celery Workers](https://airflow.apache.org/howto/executor/use-celery.html). You can monitor how many workers are currently active using Flower, visiting [localhost:5555](http://localhost:5555)

## Deploy Airflow on AWS ECS
To run Airflow in AWS we will use ECS (Elastic Container Service).

### Deploy Infrastructure using Terraform
Run the following commands:
<pre>
make infra-init
make infra-plan
make infra-apply
</pre>

or alternatively
<pre>
cd environ/dev
terraform get
terraform init -upgrade;
terraform plan
terraform apply
</pre>

By default the infrastructure is deployed in `us-east-1`.

When the infrastructure is provisioned (the RDS metadata DB will take a while) check the if the ECR repository is created then run:
<pre>
bash scripts/push_to_ecr.sh airflow-dev
</pre>
By default the repo name created with terraform is `airflow-dev`
Without this command the ECS services will fail to fetch the `latest` image from ECR

### Deploy new Airflow application
To deploy an update version of Airflow you need to push a new container image to ECR.
You can simply doing that running:
<pre>
./scripts/deploy.sh airflow-dev
</pre>

The deployment script will take care of:
* push a new ECR image to your repository
* re-deploy the new ECS services with the updated image


## AWS ECS and Fargate
Amazon Elastic Container Service (Amazon ECS) is a fully managed _container orchestration service_ […] You can choose to run your ECS clusters using AWS Fargate, which is _serverless compute for containers_. Fargate removes the need to provision and manage servers, lets you specify and pay for resources per application, and improves security through application isolation by design