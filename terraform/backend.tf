terraform {
  backend "s3" {
    bucket         = "restapi-flask-terraform-state-142517507342"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "restapi-flask-terraform-lock"
    encrypt        = true
  }
}
