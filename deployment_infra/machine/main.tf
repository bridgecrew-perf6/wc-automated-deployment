variable "enviroment_name" {}
variable "subnet_id" {}
variable "machine_size" {
  default = "t3.micro"
}

data "aws_ami" "linux" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_network_interface" "main" {
  subnet_id   = var.subnet_id

  tags = {
    Name = "${var.enviroment_name}-vm"
  }
}

resource "aws_iam_role" "wc_vm_role" {
  name = "wc_vm_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

data "aws_ssm_parameter" "ecr_registry" {
  name = "${var.enviroment_name}_ecr_registry_url"
}

data "aws_ssm_parameter" "ecr_arn" {
  name = "${var.enviroment_name}_ecr_registry_arn"
}

resource "aws_iam_role_policy" "ecr_read_policy" {
  name = "ecr_read_policy"
  role = "${aws_iam_role.wc_vm_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantSingleImageReadOnlyAccess",
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "${data.aws_ssm_parameter.ecr_arn.value}/*"
    },
    {
      "Sid": "GrantECRAuthAccess",
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "wc_vm_profile" {
  name = "wc_vm_profile"
  role = "${aws_iam_role.wc_vm_role.name}"
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.linux.id
  instance_type = var.machine_size
  iam_instance_profile = "${aws_iam_instance_profile.wc_vm_profile.name}"

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  tags = {
    Name = var.enviroment_name
  }
}