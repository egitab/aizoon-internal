terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47" # the '~>' means that version must be 5.x with x >= 47
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = "~> 1.7"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
