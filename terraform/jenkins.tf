resource "aws_instance" "jenkins_ec2" {
  ami                    = var.jenkins_ec2_ami
  instance_type          = var.jenkins_ec2_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = var.jenkins_ec2_keyname
  tags = {
    Name = var.jenkins_ec2_name
  }
}

resource "aws_security_group" "jenkins_sg" {
  name = "${var.rds_cluster_name}-jenkins_sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.rds_cluster_name}-jenkins_sg"
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins-kp" {
  key_name   = var.jenkins_ec2_keyname
  public_key = var.public_key
}
