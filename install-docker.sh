#!/bin/bash
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){

if [ $1 -ne 0 ]
then
    echo -e "$2...$R FAILURE $N"
    exit 1
else
    echo -e "$2...$G SUCCESS $N"
fi

}

if [ $USERID -ne 0 ]
then
    echo "Please run script with super user access"
    exit 2
else
    echo "You are super user"
fi

yum install -y yum-utils
VALIDATE $? "Installing yum-utils"

yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
VALIDATE $? "setting up the repository"

yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
VALIDATE $? "Installing Docker Engine, containerd, and Docker Compose"

systemctl start docker
VALIDATE $? "Starting Docker"

systemctl enable docker 
VALIDATE $? "Enabling Docker"

usermod  -aG docker ec2-user
VALIDATE $? "add ec2-user to secondary group"

echo -e "$R Logout and Login again $N"

