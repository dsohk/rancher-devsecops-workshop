#! /bin/bash -e

source $HOME/myharbor.sh

echo "Build my jenkins image with my own plugins..."
sudo docker build -t myjenkins:v1.0 -f Dockerfile.x86 .

echo "Login to Harbor private registry ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

echo "Upload myjenkins image to Harbor private registry ..."
sudo docker tag myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0
sudo docker push $HARBOR_URL/library/myjenkins:v1.0


