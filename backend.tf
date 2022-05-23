terraform {
    backend "s3" {
        key = "terraform/tfstate.tfstate"
        bucket = "myfirst-bucket-terrafoem"
        region = "us-east-1"
    }
}