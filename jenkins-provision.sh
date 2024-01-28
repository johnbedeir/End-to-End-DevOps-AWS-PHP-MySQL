#Install Java 
echo "--------------------Installing Java--------------------"
sudo apt-get update -y
sudo apt upgrade -y
sudo apt-get install openjdk-11-jdk -y
#Install Jenkins 
echo "--------------------Installing Jenkins--------------------"
if ! command -v jenkins > /dev/null 2>&1; then
    echo "Jenkins is not installed, installing..."
    
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install jenkins -y

    sudo systemctl restart jenkins

else
    echo "Jenkins is already installed."
fi
#Install Docker
echo "--------------------Installing Docker--------------------"
if ! command -v docker > /dev/null 2>&1; then
    echo "Docker is not installed, installing..."
    sudo apt-get install docker.io -y
else
    echo "Docker is already installed."
fi
#Install AWS-CLI
echo "--------------------Installing AWS-CLI--------------------"
if ! command -v aws > /dev/null 2>&1; then
    echo "awscli not found, installing..."
    sudo apt-get install awscli -y
else
    echo "awscli is already installed."
fi
#Show Jenkins Password
echo "--------------------Jenkins Password--------------------"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#Add docker to sudo group
echo "--------------------Add Docker to Sudo group--------------------"
if ! getent group docker > /dev/null 2>&1; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 777 /var/run/docker.sock
