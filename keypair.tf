# Generate a new RSA key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#public key in aws
resource "aws_key_pair" "key1"  {
    key_name = "awstfkey"  #if you want to create a new key pair, change this name
  public_key= tls_private_key.ssh_key.public_key_openssh
}

#dowload key 

resource "local_file" "localf" {
    filename = "awstfkey.pem"  # Local file name # You can change this to your desired file name
    content  = tls_private_key.ssh_key.private_key_pem  # Content of the file
  file_permission = 0400 
}



