provider "aws" {
  region = "us-east-1"
}

#add security group & traffic rules
resource "aws_security_group" "sec-grp-devops" {
  name = "sec-grp-devops"
  description = "allow ssh and web access"
  vpc_id = "vpc-39354b44"

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8
    protocol  = "icmp"
    to_port   = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create key pair to push the instances
resource "aws_key_pair" "alegria-lap" {
  key_name   = "alegria-lap"
  public_key = file("C:/Data/AWS/keys/alegria_id_rsa.pub")
}

/* ----- create instances -----------------------
resource "aws_instance" "terraform-web01" {
  ami = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
    tags = {
      Name = "terraform-web01"
  }
  security_groups =  ["sec-grp-devops"]
  key_name = "alegria-lap"

}

resource "aws_instance" "terraform-web02" {
  ami = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  	tags = {
      Name = "terraform-web02"
  }
  security_groups = ["sec-grp-devops"]
  key_name = "alegria-lap"
}
----------------------------------------------------- */
#create instances based on count Module.
resource "aws_instance" "web0" {
  count = 2
  ami = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  security_groups = ["sec-grp-devops"]
  key_name = "alegria-lap"
  tags = {
    Name = "Web0${count.index}"
  }

}
#--------------------------------------


/*-------create load balancer--------------------
  resource "aws_elb" "lb-LaKukaracha" {
  name               = "lb-LaKukaracha"
  internal           = false
  subnets            = ["subnet-9a1fedd6", "subnet-7b123d24",
  "subnet-77193b11", "subnet-5799ef66", "subnet-383dd939", "subnet-4d94bd6c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances       = [aws_instance.terraform-web01.id,aws_instance.terraform-web02.id]
  security_groups = [aws_security_group.sec-grp-devops.id]

}

-------print results-----------
 output "aws_elb" {
  value = "http://${aws_elb.lb-LaKukaracha.dns_name}"
}


output "public_dns" {
  value = "1. ssh ubuntu@${aws_instance.terraform-web01.public_dns}"
}
output "aws_instance" {
  value = "web02 = ssh ubuntu@${aws_instance.terraform-web02.public_dns}"
} */

output "aws_instance" {
  value = "web02 = ssh ubuntu@${aws_instance.web0[count.index]}"
}