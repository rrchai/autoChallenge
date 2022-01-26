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

# Install conda
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b
source ~/anaconda3/bin/activate
conda init

# Install cwl
pip3 install cwltool -y

# Install R
sudo amazon-linux-extras install R4 -y

# Allow for non-root user to manage docker
sudo groupadd R
sudo usermod -aG R $USER