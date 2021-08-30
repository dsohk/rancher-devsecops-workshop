#! /bin/bash -e

source $HOME/myharbor.sh

echo "Login to Harbor private registry ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

# Uncomment the 3 lines below if you want to build your own plugin here with docker build
# echo "Build my jenkins image with my own plugins..."
# sudo docker build -t myjenkins:v1.0 -f Dockerfile.x86 .
# sudo docker tag myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0

echo "To save time, pull the prebuilt myjenkins docker image ..."
sudo docker pull susesamples/myjenkins:v1.0
sudo docker tag susesamples/myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0

echo "Upload myjenkins image to Harbor private registry ..."
sudo docker push $HARBOR_URL/library/myjenkins:v1.0


