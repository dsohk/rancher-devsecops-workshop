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

![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg1.png)

![Rancher UI](./images/part5-modifying-sourcecode-and-running-new-build-pg2.png)

![Rancher UI](./images/part5-running-build2-seeking-approval.png)

![Rancher UI](./images/part5-running-build2-fleet-updating-in-progress.png)

![Rancher UI](./images/part5-running-build2-fleet-success.png)

![Rancher UI](./images/part5-running-build2-cluster2-Services-Open-App.png)




## 4. Check the new application

1. From Rancher UI, select `cluster1` (or cluster2) in `Cluster Explorer` UI,
2. Select Services
3. Click the link under the spring-petclinic node port service to navigate to the application homepage.
4. You should notice the text you modified is showing up in this home page.




