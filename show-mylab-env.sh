#! /bin/bash -e

if [ ! -f mylab_env.txt ]; then

  echo "Collecting your environment..."

  cat mylab_vm_list.txt > mylab_env.txt
  echo >> mylab_env.txt

  if [ -f ssh-mylab-rancher.sh ]; then
    SSH_VM=$(<ssh-mylab-rancher.sh)
    echo >> mylab_env.txt
    eval "$SSH_VM cat rancher-url.txt >> mylab_env.txt"
  fi

  if [ -f ssh-mylab-harbor.sh ]; then
    SSH_VM=$(<ssh-mylab-harbor.sh)
    echo >> mylab_env.txt
    eval "$SSH_VM cat harbor-credential.txt >> mylab_env.txt"
    echo >> mylab_env.txt
    eval "$SSH_VM cat myjenkins.txt >> mylab_env.txt"
    echo >> mylab_env.txt
    eval "$SSH_VM cat myanchore.txt >> mylab_env.txt"
    echo >> mylab_env.txt
    eval "$SSH_VM cat mysonarqube.txt >> mylab_env.txt"
    echo >> mylab_env.txt
  fi

  echo >> mylab_env.txt
  echo "My Github personal access token: " >> mylab_env.txt
  echo >> mylab_env.txt
  echo "My SonarQube token: " >> mylab_env.txt
  echo >> mylab_env.txt

fi

cat mylab_env.txt
