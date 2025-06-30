resource "aws_instance" "utc-app" {
  ami = "ami-000ec6c25978d5999" # Replace with your desired AMI ID
  instance_type = "t2.micro" 
  subnet_id = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.webserver-sg.id] # Use the security group created above
key_name = aws_key_pair.key1.key_name
user_data = file ("setup.sh") # Ensure this script exists in the same directory
 
tags = {
    Name = "Terraform-EC2-Instance"
    Environment = "dev"
  }
  depends_on = [aws_internet_gateway.igw1] # Ensure the internet gateway is created before the instance
}