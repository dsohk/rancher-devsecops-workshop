#! /bin/bash -e

git clone https://github.com/SonarSource/helm-chart-sonarqube.git
cd helm-chart-sonarqube/charts/sonarqube
helm dependency update
kubectl create namespace sonarqube

kubectl taint nodes devsecops-w1 sonarqube=true:NoSchedule
kubectl label node devsecops-w1  sonarqube=true

helm upgrade --install -f values.yaml -n sonarqube sonarqube ./



