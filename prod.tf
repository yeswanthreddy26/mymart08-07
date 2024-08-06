
provider  = aws.us-east {
 alias  = "us-west"
  region = "us-west-1"
}

resource "aws_security_group" "prod_sg" {
  name = "rds_sg"
  # Define ingress and egress rules for RDS
   # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
  }

}

resource "aws_instance" "nameprod" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.medium"
  key_name = "praveen"
  vpc_security_group_ids = [ "sg-0a5c5fa3d8e5c5b7e" ]
  tags = {
    Name = "yeswanth"
  }
  
provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get upgrade -y",
        "sudo apt install python3-pip -y",
        "sudo apt install python3-venv -y",
        "sudo apt install python3-virtualenv -y",
        "python3 -m venv /home/ubuntu/yeswanth",
        ". /home/ubuntu/yeswanth/bin/activate",
        "git clone https://github.com/yeswanthreddy26/mymart08-07.git",
        "cd mymart08-07",
        "sudo apt install openjdk-17-jdk -y",
        "sudo apt install maven -y",
        "sudo apt install gradle -y",
        "sudo apt install maven -y",
        "mvn clean package",
        "java -jar target/MyMart-0.0.1-SNAPSHOT.jar",
        "nohup java -jar target/MyMart-0.0.1-SNAPSHOT.jar > spring_boot.log 2>&1 &",
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"  
      private_key = file("praveen.pem")  
      host     = self.public_ip  
    }
 }
}
