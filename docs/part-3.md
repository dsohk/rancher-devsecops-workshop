# Part 3 - Configure Jenkins with DevSecOps tools to deploy spring-petclinic App

After we have configured and have verified Jenkins is working, let's build the spring-petclinic application. 

Prior to configuring Jenins, open your linux workstation terminal where the git repository is located.

Run the command below to show your current lab environment. This shows you all information you need to configure your Jenkins in this section.

```
./show-mylab-env.sh
```

The output should look like below.

```
Your Rancher Server URL: https://18.141.146.73

My Harbor Instance ...
URL: https://18.141.208.163:30443
User: admin
Password: ZD9YfBagvtZ3RjXoAWzpC8gq7NtBQz

Your Jenkins instance is ready ...
http://13.250.30.98:30030/login
Username: admin
Password: 6mXnCWsbJbMsq66HatLYYH

Your Anchore is now successfully provisioned.
URL: http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/
User: admin
Password: ciANbB7N2F988lyT5fIcFJKJNffVo1JU

Your Sonarqube instance is ready ...
http://13.250.30.98:30667/login
username: admin
initial password: admin


My Github personal access token:

My SonarQube token:

```

A file `mylab_env.txt` should also have created for you. Use text editor to open this file and get ready to record down your further tokens to be collected in this part.

## Setup my Github

### 1. Generate my Personal Access Token

In order to integrate Jenkins with your github account, we have to generate your personal access token for this.

1. Login to your github account
2. Under your avatar icon, pull down the menu and choose `Settings` menu item.
3. Choose `Developer Settings` menu on the left, choose `Personal Access Tokens`
4. Click `Generate new token` button.
5. Enter `workshop` (or whatever you like) in the name field.
6. Choose `repo` and `user:email` in the privieged for this token.
7. Save and record down the generated token for configuring CI Pipeline in Jenkins later.

### 2. Fork the spring-petclinic project into your own github account

Open a new Browser & past the below link

```
https://github.com/dsohk/spring-petclinic
```
Click on Fork Icon on top right hand window pane & select your own account where the repo will be forked.

In GitHub, navigate to your forked repoistory. Find the code in `Jenkinsfile` and replace `yourname` with your github account name.

![Code change after forked repo](./images/github-repo-code-change-yourname.png)

### 3. Fork the spring-petclinic-helmchart project into your own github account

Open a new Browser & past the below link

```
https://github.com/dsohk/spring-petclinic-helmchart
```
Click on Fork Icon on top right hand window pane & select your own account where the repo will be forked.

Once the above 2 Repo are forked, those repo are available in your GitHub account. 
You can check your Repositories to validate. 


## Setup my Sonarqube

Sonarqube URL & details are stored in Harbor VM. 

Execute the below script to log into Harbor
```
./ssh-mylab-harbor.sh
```

Execute the below command on the Harbor Terminal to get Sonarqube URL & Credentials.

```
cat mysonarqube.txt
```

1. Login to your Sonarqube instance with the generated credential from Part 1. Upon successful login, you will be prompt to change your inital password. 
2. Choose `Add a Project`. 

![Add Project in Sonarqube](./images/sonarqube-add-project.png)

3. Select `Manually` to continue
3. Enter `spring-petclinic` in Project Key and Display Name input field.
4. In the Provide a token input field, enter `spring-petclinic` and click `Generate Token` button.
5. Record the generate token.
6. In responding to Run Analysis on your project, choose `maven`. This will give you a code snippet as part of your Pipeline. For example,

![Generated Token in Sonarqube](./images/sonarqube-add-project-generated-token.png)

@Derek, is there somethings we need to using the above command ? 
Its say you need to run the command in your project folder. Not able to follow this?

## Setup my Jenkins

Execute the below script to log into Harbor
```
./ssh-mylab-harbor.sh
```

Execute the below command on the Harbor Terminal to get Jenkins URL & Credentials.

```
cat myjenkins.txt
```

### Configure Jenkins System

1. Login to Jenkins
2. Navigate to `Managing Jenkins`, then choose `Configure System`.

#### Setup Global Environment variables

Go to `Global Properties` section. Define the following environment variables

1. Enable Global Environment Variables by clicking in the box 

Environment Varaiable will then show list of variables where you can click on `add` to add new varaiables. 

Add 3 variables as mentioned below in step 2.

2. Add New Environment Variable
   a) Key: HARBOR_URL
   b) Value: (Your Harbor_URL) (just IP:PORT - no http:// or https://)
   
To know your Harbor URL, execute the below commands

```
./ssh-mylab-harbor.sh
```
```
cat harbor-credential.txt
```

#### Sonarqube

Click on Environment Variable Enable injection of SonarQube

Click on `Add SonarQube`

1. Name: My SonarQube (Please use the name as mentioned in the instruction) or copy & paste using below clipboard
```
My SonarQube
```
2. Add URL: (Your Sonarqube URL)

To find Sonarqube URL ssh into Harbor VM using the script below. 

```
./ssh-mylab-harbor.sh
```
```
cat mysonarqube.txt
```

3. Add generated token 
  Add Credential > Jenkins
  Kind Secret text: 
  Secret: (from Sonarqube generated token)
  ID: sonarqube-spring-petclinic

4. Sample Output would look like

![Configure Sonarqube integration in Jenkins](./images/jenkins-configure-sonarqube.png)


#### Git plugin

Specify the github username and email account in this section. It can be any arbitrary account. It will be showing up the commits to your forked helm chart repository later.

1. Global Config user.name : jenkins
2. Global Config user.email: jenkins@example.com

#### Anchore Container Image Scanner

1. Engine URL: (Your Anchore URL)
2. Engine Username: (Your Anchore username)
3. Engine Password: (Your Anchore password)

Click `Ok` button to save the Jenkins configuration settings.

### Configure the credentials

1. Navigate to the Jenkins Dashboard.
2. Choose `Manage Jenkins` on the left menu
3. Choose `Manage Credentials` on the security section.
4. Under Stores scoped to `Jenkins`, click the `(global)` dropdown menu. Choose `Add credentials`.
5. In the `Add Credentials` form, choose `Secret text` in `Kind` field.
6. Enter your Github's personal access token in the `Secret` field.
7. Enter `my-github` in the `ID` field. Please MAKE SURE this is correct as to match the value in our Jenkins Pipeline.
8. Click `OK` button to continue
9. Navigate back to the Jenkins Dashboard.

## Setup CI Pipeline for spring-petclinic project

1. Navigate to the Jenkins Dashhoard page
2. Choose `Open BlueOcean` item in the left menu
3. Click `New Pipeline` button
4. Choose `Github` tor respond to Where do you store your code question.
5. Enter your Github personal access token and click `Connect`
6. Choose your github organization.
7. Choose your forked project `spring-petclinic` and click `Create Pipeline` to continue.

![BlueOcean - Create Pipeline in Jenkins](./images/jenkins-blueocean-create-pipeline.png)

Click `Build Now` to run this pipeline. 

It may take about 20 minutes to finish this pipeline at  the first time. The next run will be faster as all the builds or dependent artifacts are cached in the persistent volume used by the pods for this job.


While we are waiting the first run of this pipeline executing, let's move on to the [Part 4 - Rancher Continuous Delivery](./docs/part-4.md). We will come back to revisit the pipeline later. 


