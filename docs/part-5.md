# Part 5 - Put Everything Together

Now, let's modify the source code of the `spring-petclinic` application in Github and commit the changes into `main` branch. We'd expect a new pipeline job will be triggered via Github. 

## 1. Setup your screen layout 

Let's setup your screen layout like below so as to monitor the auto-triggering of Pipeline and Rancher Continuous Delivery.

## 2. Modify source code

1. Navigate to your `spring-petclinic` repo on github with a browser.

2. In the code section, locate this file:

```
src > main > resources > templates > welcome.html
```
Sample Output

![Rancher UI](./images/part5-modifying-sourcecode-original-welcome-message.png)

3. Modify the file `welcome.html`. Change the greeting text in line 10 from `Hi SUSE Rancher friends!` to anything you like.

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

Fleet update in the background is happening. 
![Rancher UI](./images/part5-running-build2-fleet-updating-in-progress.png)

Fleet is update successfully with the lastest (second build)

![Rancher UI](./images/part5-running-build2-fleet-success.png)

Open Browser & hit the App URL

![Rancher UI](./images/part5-running-build2-cluster2-Services-Open-App.png)

We have sucessfully build our CI/CD pipeline with SUSE Rancher





