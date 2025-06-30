terraform {
  backend "s3" {
    bucket = "okayweek7tfstate"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile  = true
  }
}

