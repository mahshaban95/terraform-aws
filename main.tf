# Select the provider and region.

provider "aws"{
    region = var.region   # You can chenge the region in the "variables.tf" file.
}

# Optional:
    # Before creating the resourcs for the project, please check the "bucket.tf" file.
    # I manully created an S3 bucket to store the terraform state file as a best practice.


# I saw a lot of AWS projects with terraform, most of them organize the tf files and folders based on the AWS resources.
# I come from on-prem backgroud. I was responsible for planning different projects with different technologies,
# The common factor is that we used to organize the infrastructure in terms of networking, storage and compute infrastructure.
# This is how I will organize the tf files in this project.

# The first thing is to design the network infrasructure.
# I created a local module for that to keep things organized.

# Now go to "main.tf" in the network module to see how network resources are designed and provisioned.
module "aws_network_module" {
    source = "./aws_network_infra"    
}


# The second thing is to design the compute infrasructure.
# I created a local module for that to keep things organized.

# Now go to "main.tf" in the compute module to see how compute resources are designed and provisioned.
module "aws_compute_module" {
    source = "./aws_compute_infra"   
    public_subnet_id = module.aws_network_module.public_subnet_id
    private_subnet_id = module.aws_network_module.private_subnet_id
    main_vpc = module.aws_network_module.main_vpc
}

# This is the end of this project for now!
# In the future I will try to add more complexity to the project as well as create a storage module.