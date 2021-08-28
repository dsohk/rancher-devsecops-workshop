# Part 3 - My Jenkins Pipeline for spring-petclinic App

After we have configured and verify Jenkins is working, let's build the spring-petclinic application.

## Github - Generate my Personal Access Token

In order to integrate Jenkins with your github account, we have to generate your personal access token for this.

1. Login to your github account
2. Under your avatar icon, pull down the menu and choose `Settings` menu item.
3. Choose `Developer Settings` menu on the left, choose `Personal Access Tokens`
4. 

My Avatar
  => Settings
  => Developer Settings
  => Personal Access Tokens
     - Generate new token
       name: workshop
       rights: repo, user:email
     - Copy the generated token

2. Fork the spring-petclinic project into your own github account

https://github.com/dsohk/spring-petclinic

3. From the spring-petclinic-helmchart project into your own github account

https://github.com/dsohk/spring-petclinic-helmchart

Update the values.yaml to replace harbor.example.com with your harbor URL (IP:PORT).


# Sonarqube

1. Login to sonarqube with initial password and change to your own one.
2. Add a project > Manually
3. Project Key: spring-petclinic (same for display name)
4. Provide a token: spring-petclinic (then click Generate token)
5. Record your spring-petclinic token:d5ef563080f0aa24f29500700f7aae2c543c3e56
6. Run analysis on your project: maven

mvn sonar:sonar \
  -Dsonar.projectKey=spring-petclinic \
  -Dsonar.host.url=http://18.139.3.119:30707 \
  -Dsonar.login=f968d62703a0bf73fd1acd70cc5108fd26e61d67




# Jenkins

Setup Global Environment variables


Configure Credentials

Managing Jenkins > Manage Credentials

https://www.jenkins.io/doc/book/using/using-credentials/

Manage Jenkins > Configure System > Global propersties section

https://www.lambdatest.com/blog/set-jenkins-pipeline-environment-variables-list/

${YOUR_JENKINS_HOST}/env-vars.html

${env.BUILD_NUMBER}




Setup first pipeline

Left menu:
  Open BlueOcean
  Create a New Pipeline
  -> Choose Github
  -> Enter your personal access token
  -> Choose spring-petclinic project 
