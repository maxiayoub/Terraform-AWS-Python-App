# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Demo VPC"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Grant the internet access to VPC by updating its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.demovpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demogateway.id
}

# Creating 1st subnet 
resource "aws_subnet" "demosubnet1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block             = var.subnet1_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Demo subnet 1"
  }
}


# Creating EC2 instance in subnet 1
resource "aws_instance" "my_ec2" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.demosubnet1.id
  vpc_security_group_ids = [ aws_security_group.example.id ]
  key_name = "test_key"

  tags = {
    Name = "Python-App_EC2"
  }
}


resource "aws_security_group" "example" {
  # ... other configuration ...
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demovpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
# Configure eip resource
resource  "aws_eip" "my_eip"{
    vpc = true
}

# Associate eip to the ec2
resource "aws_eip_association" "associate"{
    instance_id=aws_instance.my_ec2.id
    allocation_id=aws_eip.my_eip.id
}


# output/print the eip
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
