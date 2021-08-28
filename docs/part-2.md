# Part 2 - My First Jenkins Pipeline


https://www.lambdatest.com/blog/set-jenkins-pipeline-environment-variables-list/


# Github.com

1. Generate Personal Access Token at github

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

Configure Credentials

Managing Jenkins > Manage Credentials

https://www.jenkins.io/doc/book/using/using-credentials/




Setup first pipeline

Left menu:
  Open BlueOcean
  Create a New Pipeline
  -> Choose Github
  -> Enter your personal access token
  -> Choose spring-petclinic project 
