module "airflow-vpc" {
  source     = "../infrastructure/"
  stage      = "dev"
  aws_region = var.aws_region
}