provider "aws" {
  region = "us-east-1"
}

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
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "alegria-lap" {
  key_name   = "alegria-lap"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZqAvvd4hYJqcW/Z6ScQwZFvHAeSKcKVk1RPKzg/nNk9vOt1T0YlzpkzRVLW9NG6vAs6vY2ZwDu2rBLVULSMnhBNvkkYdm7kbqZgJ/nlp6OV+LEvMpq2LVgHI4yWCxt02limGylkPsavGP9FrVW0UV1mWG8ObPQ8mfF1YhYfbh4h49q6ffsAuFAKQLoq///Ih8ikuoEJeZdFkN9NU9ofKlAxBw5D1W1yORYae8kAqXsg5AJaa/SFV/OsUsiEI6SZY2gyRePMRupoLKJS9t1AtqFao/MXa97QA0R5EJq4BUri3/+nlzMs5I/nSizUzIGnIdR1u+B36aiRtwaUfVT0BelPAVmPnaHhncdjVriJozIp4dh5KSdfqaYjZvEL28SLj9P9dEjmVQ8yy9pu69E1UCz9eApkmKB472DJrsDR/pWY5dzUwxxtsahL70J/feuRgnR892yPOwkrRGRi1U29jtTJMm/FIK8V/6TfxdzoxImgKpXpgWfLEFF7I8ux1RSEM= alegria@Alegria-Lap01"
}

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
  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  instances       = [aws_instance.terraform-web01.id,aws_instance.terraform-web02.id]
  security_groups = [aws_security_group.sec-grp-devops.id]

}

output "aws_elb" {
  value = "http://${aws_elb.lb-LaKukaracha.dns_name}"
}
output "public_dns" {
  value = "web01 = ssh ubuntu@${aws_instance.terraform-web01.public_dns}"
}
output "aws_instance" {
  value = "web02 = ssh ubuntu@${aws_instance.terraform-web02.public_dns}"
}