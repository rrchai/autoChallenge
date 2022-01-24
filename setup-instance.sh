#!/bin/bash

# Install docker and git
sudo yum install docker git -y

# Start the docker service
sudo service docker start

# Allow for non-root user to manage docker
sudo groupadd docker
sudo usermod -aG docker $USER

# Install docker-compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install cwl
pip3 install cwltool