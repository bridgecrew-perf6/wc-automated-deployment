# Simple Word Counter With Deployment Automation

### Keypoints
- Need to run scripts to setup terraform s3 backend for terraform state (command line, onetime task)
- Created a seperate github workflow for create ECR Registry
- Created a seperate github workflow for create Deployment Infrastructure
- As a Sub Step of Deployment Infrastructure workflow running docker installing
- ec2 access is doing with aws system manager
- ECR registry access is configured using IAM role attached to the instance
- When there is a change to word_count folder inside the repository docker images will be built the with changes and pushed to the registry. 

## Installation

##### Prerequisite 

- Need to have terraform 1.1.17 on local machine
(https://tfswitch.warrensbox.com/Quick-Start/)

- AWS Programatic credentials with Admin arn:aws:iam::aws:policy/AdministratorAccess
(Script creates IAM roles inorder to do this needs AdministratorAccess access)


### Steps

##### Repository Setup
- Fork this repository into your github account
- Set following secrets on forked repo secrets Settings > Secrets > Actions > New repository secret
```text
WC_EC2_INSTANCE_ID=<Create Empty Need to fill this after run infrastructure workflow>
WC_SSH_PASSWORD=<set some password for setup ssh access> 
WC_TF_AWS_ACCESS_KEY=<AWS ACCESS Key>
WC_TF_AWS_SECRET_KEY=<AWS SECRET Key>
```
##### Terraform backend Setup
- Clone main branch into your local machine
- Go to tf_backend folder and remove .terraform.lock.hcl, terraform.tfstate, terraform.tfstate.backup
```bash
git clone git@github.com:kokigit/wc-automated-deployment.git

cd wc-automated-deployment/tf_backend
rm .terraform.lock.hcl
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -backend-config="access_key=REPLACE_THIS_WITH_ACCESS_KEY>" -backend-config="secret_key=REPLACE_THIS_WITH_SECRET_KEY"

terrafom apply terraform apply -var='aws_access_key=REPLACE_THIS_WITH_ACCESS_KEY' -var='aws_secret_key=REPLACE_THIS_WITH_SECRET_KEY'

git commit -a -m "Update terraform backend"
git push
```