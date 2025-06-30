# Security Group 

resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  description = "Allow webtraffic and SSH"
  vpc_id      = aws_vpc.vpc1.id

  # INBOUND RULES (Ingress)
  ingress {
    description = "SSH from specefic ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["174.238.7.182/32"]  # Restrict to your IP (replace this)
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public access
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUND RULES (Egress) #don't need to specify if you want to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "webserver-sg"
  }
  depends_on = [ aws_vpc.vpc1 ]
}