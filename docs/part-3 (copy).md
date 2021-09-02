# Part 3 - Configure Jenkins Pipeline to deploy spring-petclinic App

After we have configured and have verified Jenkins is working, let's build the spring-petclinic application. 

Prior to configuring Jenkins, open your Linux workstation terminal where the git repository is located.

Run the command below to show your current lab environment. This shows you all information you need to configure your Jenkins in this section.

```
./show-mylab-env.sh
```

The output should look like below.

```
Your Rancher Server URL: https://52.221.224.193

My Harbor Instance ...
URL: https://18.138.241.59:30443
User: admin
Password: V4P6Z8NA3yXpEjrpIjPl9O05ITnXhM

Your Jenkins instance is ready ...
http://13.251.59.142:31409/login
Username: admin
Password: DIY1aHNzqfn3Hk79L7UeQ8

Your Jenkins Github webhook Payload URL:
http://13.251.59.142:31409/github-webhook/

Your Anchore is now successfully provisioned.
URL: http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/
User: admin
Password: ZuhWUXq0BvKfnCgHP4eqIIIVVR6oKzko

Your Sonarqube instance is ready ...
http://13.251.59.142:30612/login
username: admin
initial password: admin


My Github personal access token:

My SonarQube token:

```

A file `mylab_env.txt` should also have created for you. Use text editor to open this file and get ready to record down your further tokens to be collected in this part.

## Setup my Github to create personal access token & webhook for forked repo.


### 2. Setup git webhook for spring-petclinic repo to your Jenkins server

1. Click `Settings` in your spring-petclinic github repo.
2. Choose `Webhooks` from the left menu.
3. Click `Add Webhook` button
4. Enter Payload URL: http://<YOUR_JENKINS_IPADDRESS>:<YOUR_JENKINS_PORT>/github-webhook/
5. Choose `Send me everything` for events to trigger this webhook.
6. Click `Add Webhook` button.

![Setup Github webhook](./images/github-webhook.png)

### 3. Fork the spring-petclinic project into your own github account

Open a new Browser & past the below link

```
https://github.com/dsohk/spring-petclinic
```

Click on Fork Icon on top right hand window pane & select your own account where the repo will be forked.

![Forked repo visibility in your GitHub Account](./images/step3-part2-forking-spring-petclinic.png)

In GitHub, navigate to your forked repoistory. Find the code in `Jenkinsfile` and replace `yourname` with your github account name.

Click on the Jenkinsfile to open & click on `pencil/pen` like icon next to words `Raw | Blame` on right hand top page to edit the file to make changes to you forked repo in Github
![Forked repo visibility in your GitHub Account](./images/step3-part2-forking-spring-petclinic-how-to-edit-jenkinsfile.png)

Look for section below in Jenkin files & replace `yourname` to `Your Github ID`
![Code change after forked repo](./images/github-repo-code-change-yourname.png)

Sample Output for reference.
![Code change after forked repo](./images/step3-part2-forking-spring-petclinic-editing-jenkinsfile-changing-userid.png)

Once the changes are made, scroll down to the bottom of the page & hit `Commit changes` which will commit your change to the `Main` branch of your forked repo. 

![Saving changes to forked repo](./images/step3-part2-forking-spring-petclinic-making-changing-userid-save.png)


### 4. Fork the spring-petclinic-helmchart project into your own github account

Open a new Browser & past the below link

```
https://github.com/dsohk/spring-petclinic-helmchart
```
Click on Fork Icon on top right hand window pane & select your own account where the repo will be forked.

Once the above 2 Repo are forked, those repos are available in your GitHub account. You can check your Repositories to validate. 

![Saving changes to forked repo](./images/step3-part2-2-fork-repo-success.png)




## Setup my Jenkins

### Configure Jenkins with GitHub credentials 

1. Login to Jenkins
2. Navigate to the Jenkins Dashboard.
2. Choose `Manage Jenkins` on the left menu
3. Choose `Manage Credentials` on the security section.
4. Under Stores scoped to `Jenkins`, click the `(global)` dropdown menu. Choose `Add credentials`.
5. In the `Add Credentials` form, choose `Secret text` in `Kind` field.
6. Enter your Github's personal access token in the `Secret` field.
7. Enter `my-github` in the `ID` field. Please MAKE SURE this is correct as to match the value in our Jenkins Pipeline.
8. Click `OK` button to continue
9. Navigate back to the Jenkins Dashboard.


### Configure Jenkins with Sonarqube credentials

* Server authentication token: (Click `Add`) to pull down menu and choose `Add Credentials`. If a popup windows does not come up, hit `save` & revist this section again.  

Now clicking `Add` should bring up a windows `Jenkins Credentials Provider: Jenkins` to add credentials.

In the popup window, 
  * Kind: click on dropdown menu to select `Secret text`
  * Secret: (Enter the Sonarqube generated token)
  * ID: `sonarqube-spring-petclinic`

Under `Server authentication token` use the drop down option and you should see `sonarqube-spring-petclinic`. Select it. 



### Configure Jenkins System

1. Login to Jenkins
2. Navigate to `Managing Jenkins`, then choose `Configure System`.

#### Setup Global Environment variables

1. Login to Jenkins
2. Navigate to `Managing Jenkins`, then choose `Configure System`.

Go to `Global Properties` section.

1. Enable `Environment Variables` checkbox
2. Click `Add` button to continue.
3. Add New Environment Variable
   * Key: `HARBOR_URL`
   * Value: (Your Harbor_URL) (just IP:PORT - no http:// or https://)

![Configure Global Variables in Jenkins](./images/jenkins-configure-global-vars.png)

#### Sonarqube

Enable `Environment variables` checkbox

In the `Sonarqube installations` click on `Add SonarQube`
section, enter the following.

* Name: `My SonarQube` Note name must spelled excatly as mentioned here.
* Server URL: (Your SonarQube URL)

Under `Server authentication token` use the drop down option and you should see `sonarqube-spring-petclinic`. Select it. 

![Configure Sonarqube integration in Jenkins](./images/jenkins-configure-sonarqube.png)

----------------------
Would remove this section post testing.. 
* Server authentication token: (Click `Add`) to pull down menu and choose `Add Credentials`. If a popup windows does not come up, hit `save` & revist this section again.  

Now clicking `Add` should bring up a windows `Jenkins Credentials Provider: Jenkins` to add credentials.

In the popup window, 
  * Kind: click on dropdown menu to select `Secret text`
  * Secret: (Enter the Sonarqube generated token)
  * ID: `sonarqube-spring-petclinic`

Under `Server authentication token` use the drop down option and you should see `sonarqube-spring-petclinic`. Select it. 

Sample Output should show up as below.

----------------------------------------------------------

#### Git plugin

Specify the github username and email account in this section. It can be any arbitrary account. It will be showing up the commits to your forked helm chart repository later.

1. Global Config user.name : jenkins
2. Global Config user.email: jenkins@example.com

#### Anchore Container Image Scanner

1. Engine URL: (Your Anchore URL)
2. Engine Username: (Your Anchore username)
3. Engine Password: Click on `change Password` and replace with your Anchore password)

Click `Save` button to save the Jenkins configuration settings.

### Configure the credentials in Jenkins

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

Click `Build Now` to run this pipeline. 

We see the Jenkins build job status in Jenkins and we also see the corresponding Jenkins worker running the container build job in `Jenkins-workers` Namespace with job id `spring-petclinic-b6f6771f-ss3vx-fccj4`

![Build Job In Action](./images/spring-petclininc-pipeline-buildingstate-underprogress.png)

On successful completion of the job. Sample below

![Build Job Completed - Success](./images/spring-petclininc-pipeline-buildingstate-successful.png)

It may take about 20 minutes to finish this pipeline at  the first time. The next run will be faster as all the builds or dependent artifacts are cached in the persistent volume used by the pods for this job.


While we are waiting the first run of this pipeline executing, let's move on to the [Part 4 - Rancher Continuous Delivery](part-4.md). We will come back to revisit the pipeline later. 


