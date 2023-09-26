#Data  Source

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["${var.image_name}"]

  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


#Create Instance

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]

  tags = {
    Name = "second-tf-instance"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
EOF


  # #File Provisioner Connection

  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("${path.module}/id_rsa")
  #   host        = "${self.public_ip}"

  # }

  # provisioner "file" {
  #   source      = "readme.md"      #terraform machine
  #   destination = "/tmp/readme.md" #remote machine

  # }
  # provisioner "file" {
  #   content     = "this is test content" #terraform machine
  #   destination = "/tmp/content.md"      #remote machine
  # }

  #   provisioner "local-exec" {
  #     working_dir = "/tmp/"
  #     command = "echo ${self.public_ip} > mypublicip.txt"    
  #   }

  #   provisioner "local-exec" {
  #     working_dir = "/tmp/"
  #     interpreter = [ 
  #         "/usr/bin/python3", "-c"
  #      ]
  #     command = "print('Hello World')"    
  #   }

  # provisioner "local-exec" {
  #   command = "env>env.txt"
  #   environment = {
  #     envName = "envValue"
  #   }

  # }
  # provisioner "local-exec" {
  #   command = "echo 'at Create'"

  # }
  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "echo 'at delete'"

  # }
}

