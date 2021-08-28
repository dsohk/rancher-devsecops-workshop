# Part 3 - My Jenkins Pipeline for spring-petclinic App

After we have configured and verify Jenkins is working, let's build the spring-petclinic application.

## Setup my Github

### 1. Generate my Personal Access Token

In order to integrate Jenkins with your github account, we have to generate your personal access token for this.

1. Login to your github account
2. Under your avatar icon, pull down the menu and choose `Settings` menu item.
3. Choose `Developer Settings` menu on the left, choose `Personal Access Tokens`
4. Click `Generate new token` button.
5. Enter `workshop` (or whatever you like) in the name field.
6. Choose `repo` and `user:email` in the privieged for this token.
7. Save and record down the generated token.

### 2. Fork the spring-petclinic project into your own github account

https://github.com/dsohk/spring-petclinic

### 3. Fork the spring-petclinic-helmchart project into your own github account

https://github.com/dsohk/spring-petclinic-helmchart

Update the values.yaml to replace harbor.example.com with your harbor URL (IP:PORT).


## Setup my Sonarqube

1. Login to your Sonarqube instance with the generated credential from Part 1.
2. Choose `Add a Project`. Select `Manually` to continue
3. Enter `spring-petclinic` in Project Key and Display Name input field.
4. In the Provide a token input field, enter `spring-petclinic` and click `Generate Token` button.
5. Record the generate token.
6. In responding to Run Analysis on your project, choose `maven`. This will give you a code snippet as part of your Pipeline. For example,

```
mvn sonar:sonar \
  -Dsonar.projectKey=spring-petclinic \
  -Dsonar.host.url=http://18.139.3.119:30707 \
  -Dsonar.login=f968d62703a0bf73fd1acd70cc5108fd26e61d67
```

## Setup my Jenkins

### Configure Jenkins System

1. Login to Jenkins
2. Navigate to `Managing Jenkins`, then `Configure System` and go to `Global Properties` section.

#### Setup Global Environment variables

Define the following environment variables

key: HARBOR_URL
value: (Your Harbor_URL)

#### Anchore Container Image Scanner

1. Engine URL: (Your Anchore URL)
2. Engine Username: (Your Anchore username)
3. Engine Password: (Your Anchore password)

#### Git plugin

1. Global Config user.name : jenkins
2. Global Config user.email: jenkins@example.com


### Configure the credentials

1. In Jenkins, navigate to `Managing Jenkins`, then `Manage Credentials`



### Setup CI Pipeline for spring-petclinic

Left menu:
  Open BlueOcean
  Create a New Pipeline
  -> Choose Github
  -> Enter your personal access token
  -> Choose spring-petclinic project 
