module "kubernetes" {
  source       = "./modules_local"
  cidr_block   = "10.34.0.0/16"
  project_name = "restapi"
  region       = "us-east-1"
  tags = {
    Departament = "DevOps"
  }
}
