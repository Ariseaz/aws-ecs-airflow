terraform {
    backend "s3" {
        bucket = "az1-terraform"
        key = "environ/dev/key"
        region = "us-east-1"
    }
}