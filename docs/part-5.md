# Part 5 - Put Everything Together

Watch a video to explain what we are going to do in part 5:

[![Workshop Part 5](https://img.youtube.com/vi/1vqZvtFKYbI/0.jpg)](https://www.youtube.com/watch?v=1vqZvtFKYbI)

## 1. Modify source code

In part 4, you successfully build our containerized application and it's running. 

In this step, you will modify the source code for `spring-petclinic` application. 

1) Login into your GitHub account. Navigate to your `spring-petclinic` repository. 

2) In the code section, locate below file:

```
src > main > resources > templates > welcome.html
```
![Rancher UI](./Images-10-13-2021/part5-modifying-sourcecode-original-welcome-message.png)

3) Modify `welcome.html` file content. Line 10 contain greeting text `Hi SUSE Rancher friends!`. You can change the greeting message to your desired one.

4) Click `Commit Changes` button to save your changes. 

## 3. Observe the new pipeline being built

Please open and login to the following system with your favourtie browser open to view the progress. 

Login to your Jenkins, Jenkin UI > `Job` > `Status` > `Console Output`

Login to Rancher, Rancher UI > `Explorer` > `devsecops` > `Workload` > `Pods` > `Namespace` > `Jenkins`

In a new window, Rancher UI > `Global Apps` > `Continous Delivery` > `Git Repo`

a) In the above step, you have modified your source code. This will trigger a new pipeline job in Jenkins.

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-start-pg0.png)

b) Below screenshot indicates it's in container creation stage.

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-start-pg1.png)


c) Anchore has completed container image scanning phase and post that we get to the Approval junction.

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-approval-pg2.png)

d) Once the changes are accepted by clicking on `Yes` GitHub would be updated with new container image version and then the new image will be pushed to Harbor. You can login into Harbor to verify the same. You should see v1.0.2 as the lastest container image for the application. Same time the previous build container will terminate.

![Harbor UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-container-shipping-Habor-pg6.png)


![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-approval-pg3-previous-build-terminating-pg3.png)

You will see Build1 (v1.0.1) containaer is up and running (1/1), however build2 container (v1.0.2) is been coming up (0/1)

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-Fleet-updating.png)

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-approval-pg4-latest.png)

e) Check Git Repo status in Rancher UI and the status would be in `active` state, 

Rancher UI > `Global Apps` > `Continous Delivery` > `Git Repo`

![Rancher UI](./Images-10-13-2021/part5-pet-clinic-pipeline-build-ver2-job-success-pg5.png)

f) In Rancher UI > `Global Apps` > `Cluster Explorer` `Cluster2` > `Service Discovery` > `Services` 

![Rancher UI](./Images-10-13-2021/part6-pet-clinic-pipeline-build-ver2-App-running-cluster2-pg7.png)

We expect to see application version `1.0.2` and updated welcome message `Hi SUSE Rancher Parnter Community! Welcome aboard on this DevSecOps workshop!` and sure we do see...

You have successfully made changes to our code in GitHub, Git remain single source of truth. 

Congratulation! you have sucessfully build our CI/CD pipeline with SUSE Rancher for continuous development and delviery. We hope you have enjoyed exploring a little of what Rancher can do to your kubenetes development, deplyment, and management.

**When you have finished playing with your lab environment go to Part 6 - Cleaning up the lab environment**



