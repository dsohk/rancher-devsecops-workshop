#! /bin/bash -e

echo "Download docker images for sample application build..."

source $HOME/myharbor.sh

sudo docker pull maven:3-jdk-8-slim
sudo docker tag maven:3-jdk-8-slim $HARBOR_URL/library/java/maven:3-jdk-8-slim
sudo docker push $HARBOR_URL/library/java/maven:3-jdk-8-slim

sudo docker pull susesamples/sles15sp3-openjdk:11.0-3.56.1
sudo docker tag susesamples/sles15sp3-openjdk:11.0-3.56.1 $HARBOR_URL/library/suse/sles15sp3-openjdk:11.0-3.56.1
sudo docker push $HARBOR_URL/library/suse/sles15sp3-openjdk:11.0-3.56.1

echo
echo
echo ============================================================
echo "Congrats! Your Harbor instance has been setup successfully."
cat harbor-credential.txt
echo

