# Part 5 - Put Everything Together

Watch a video to explain what we are going to do in part 5:

[![Workshop Part 5](https://img.youtube.com/vi/1vqZvtFKYbI/0.jpg)](https://www.youtube.com/watch?v=1vqZvtFKYbI)

## 1. Modify source code

In part 4, you successfully build our containerized application and it's running. 

In this step, you will modify the source code for `spring-petclinic` application. 

1. Login into your GitHub account. Navigate to your `spring-petclinic` repository. 

2. In the code section, locate below file:

```
src > main > resources > templates > welcome.html
```
![Rancher UI](./images/part5-modifying-sourcecode-original-welcome-message.png)

3. Modify `welcome.html` file content. Line 10 contain greeting text `Hi SUSE Rancher friends!`. You can change the greeting message to your desired one.

![Rancher UI](./images/part5-modifying-sourcecode-welcome-message-modified.png)

4. Click `Commit Changes` button to save your changes. 

## 3. Observe the new pipeline being built

In the above step, you have modified your source code. This will trigger a new pipeline job in Jenkins.

![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg1.png)

The new pipeline will go through it's cycle. Below screenshot indicates it's in container creation stage.

![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg2.png)

Anchore has completed container image scanning phase and post that we get to the Approval junction.

![Rancher UI](./images/part5-running-build2-seeking-approval.png)

Once the changes are accepted by selecting `Yes` GitHub would be updated with new container image version and then the new image will be pushed to Harbor. You can login into Harbor to verify the same.

![Rancher UI](./images/part5-running-build2-container-image-v2-in-harbor.png)

Rancher Continuous Delivery process will be trigged with version update in GitHub.

![Rancher UI](./images/part5-running-build2-Rancher Continuous Delivery-updating-in-progress-git-repo-status-pg1.png)

You will see Build1 (v1.0.1) containaer is up and running (1/1), however build2 container (v1.0.2) is been coming up (0/1)

![Rancher UI](./images/part5-build2-container-coming-up-on-cluster1.png)

In a few seconds, we will see the build2-v1-0-2 container up and running & build1-v1-0-1 getting terminated. 

![Rancher UI](./images/part5-build2-v1-0-2-container-coming-up-v1-0-1-terminated-cluster1.png)

Now, let look at the GitRepo status, 

![Rancher UI](./images/part5-build2-git-repo-status-active-after-successfully-build-v1-0-2.png)

Let go to Services Page

![Rancher UI](./images/part5-build2-cluste1-services-page.png)

To open the applicatin, click on `NodePort` to and the application will open in a new browser window.

We expect to see application version `1.0.2` and updated welcome message `Hi SUSE Rancher Parnter & Community friends!` and sure we do see...

![Rancher UI](./images/part5-build2-cluster1-v1-0-2-success.png)

We have successfully makes changes to our code, Jenkins has picked up the changes and build the application in a new pipeline on Rancher RKE cluster. 

We have sucessfully build our CI/CD pipeline with SUSE Rancher





