# This is my first AWS with Terraform project

You know what AWS is! You know what terrraform is! So, let's get started right away.\
This project is built for me to learn how to build AWS resources from scratch without using remote modules.

## Getting started right away

1. Install Terraform on your local machine (I am using an Ubuntu VM).

2. Create an IAM user and get the "Access key ID" and "Secret access key"
    * Do not get the user full access to everything. Give him access only to the needed resources to ensure your following the least privilege princibles for better security practices.

3. Set the keys from step #2 as environementa variables. (Not best practices, I will use other more secure ways to handles secrets later)
    * You can also just install AWS CLI and configure you credentials there. (Also, not a best practice but that is what I did for this demo for now).

4. Now just go to "main.tf" and follow the explanation there :smiley:

5. After going through the code and changing the variables at your convience, you just need to run the following commands in the project directory:

    ```shell
    terraform init
    terraform plan
    terraform apply
    ```

### Please note that this is a work on progress. I will keep updating this repo and adding more complex components.