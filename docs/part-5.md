# Part 5 - Put Everything Together

Watch a video to explain what we are going to do in part 5:

[![Workshop Part 5](https://img.youtube.com/vi/1vqZvtFKYbI/0.jpg)](https://www.youtube.com/watch?v=1vqZvtFKYbI)

Now, let's modify the source code of the `spring-petclinic` application in Github and commit the changes into `main` branch. We'd expect a new pipeline job will be triggered via Github. 

## 1. Modify source code

1. Navigate to your `spring-petclinic` repo on github account.

2. In the code section, locate this file:

```
src > main > resources > templates > welcome.html
```
Sample Output

![Rancher UI](./images/part5-modifying-sourcecode-original-welcome-message.png)

3. Modify the file content `welcome.html`. Change the greeting text in line 10 from `Hi SUSE Rancher friends!` to anything you like.

Sample Output 

![Rancher UI](./images/part5-modifying-sourcecode-welcome-message-modified.png)

4. Click `Commit Changes` button to continue.

## 3. Observe the new pipeline is running

Observe the new pipeline job is executing to pick up the changes in github and build a new container image for it. After passing all checking, the new build number of this image will be updated in helm chart, which, in turn, will be picked up by Rancher Continuous Delivery to propagate the changes into the target clusters.

Pipeline - Build Job 2 is been build
![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg1.png)

The new build has completed its static and dynamic code testing & is presently in container creation stage as we see below. 

![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg2.png)

Anchore has also completed the container image scanning and we finally the approval junction.

![Rancher UI](./images/part5-running-build2-seeking-approval.png)

Once the approval is provided, the newly container image is then pushed to Harbor

![Rancher UI](./images/part5-running-build2-container-image-v2-in-harbor.png)

------------------------------------------------------------

New 

Rancher Continuous Delivery update in the background is happening. 
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





