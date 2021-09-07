# Part 4 - Rancher Fleet - Continous Delivery 

Watch a video to explain what we are going to do in part 4:

[![Workshop Part 4](https://img.youtube.com/vi/cjPNjb9e8NI/0.jpg)](https://www.youtube.com/watch?v=cjPNjb9e8NI)


## 1. Configure Rancher Fleet - Continous Delivery

To setup Fleet, from Rancher UI, Cluster Manager View  select `Tools` and click on `Continous Delivery`

![Rancher-Continous Delivery (CD)](./images/rancher-uI-fleet-step1-pg1.png)

Under Continous Delivery, you have following options
1) Git Repo
2) Clusters
3) Cluster Groups 
4) Advance

Before we go any further, let verify if we can see all our cluster in Continous Delivery(Rancher Fleet)

![Rancher-(CD)](./images/rancher-uI-all-clusterlist-step2.png)

With Rancher Fleet you can manage indivisual or group of clusters. Managing cluster via Group reduces adminstrative efforts. 

### Create a Cluster Group
Continous Delivery > Cluster Group > click on `Create`

![Rancher UI](./images/rancher-ui-create-first-fleet-group-step3-pg3.png)

Provide same Label key value pair which was used to create `Cluster1` and `Cluster2`
Key:Value `(env=dev)` 

Once you key in the key:value pair, Rancher will use the selector labels to indentify the clusters to be associated with our newly created cluster group in Fleet. You will see it show 2/4 cluster been selected. 

![Rancher UI](./images/rancher-ui-create-first-fleet-group-details-step4-pg4.png)

Hit `Create` which will create our first Cluster Group.

![Rancher UI](./images/rancher-ui-first-fleet-group-success-step5-pg5.png)

### Configure Git Repo

Before we ahead for configuring the Git Repo, we need to Git Repository URL.

Follow the instruction below to get to Git Repository URL.

Open you GitHub. You will find your repository on left hand side of the page. If you still not able to find, use the search option and specify the repository name `spring-petclinic-helmchart` 

Click on the Repository URL and you will be taken into the `code` tab. 

In the code page, you will be in the `main` branch. Click on `code` tab, use the drop down menu and you will be presented with the repositroy url. 
Click on the clipboard icon to copy the URL from `HTTPS` tab. 

Sample below for reference. 

![Rancher UI](./images/part4-configure-git-repo-forked-url.png)

We are now ready to Configure our Git Repo

Note: Branche Name is `main` and not `master`

Sample output of the GitRepo configuration below

![Rancher UI](./images/part4-configure-git-repo-config.png)

Since the pipeline is in progess while you are configuring Fleet, we expect the below output 

![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-1.png)

Side by Side view of Jenkins Pipeline & Rancher CD (Fleet)
![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-2.png)



Side by Side view of Jenkins Pipeline & Harbor 
![Rancher UI](./images/part4-configure-git-repo-status-pipeline-in-progress-container-created-in-harbor-pg4.png)

At one point in pipline we will reach the approval stage to commit the code to the GitHub Repo (Forked on in our personal Github) 

![Rancher UI](./images/part4-configure-git-repo-approval-stage.png)

## Fleet in Action.
Post approval stage, Jenkins commits the changes to GitRepo and Fleet is watching the Branch for new commits. 
Fleet has picked up the changes and is not deploying the bundles in Cluster Group

![Rancher UI](./images/part4-fleet-status-ready.png)

In Rancher UI, click on Cluster Explorer for either `Cluster1` or `Cluster2`. Click on the pods section and we should see our Spring PetClinic Conatiner running. Take a closer look at the version, it should say `spring-petclinic:v1.0.x`.

illustration below.

![Rancher UI](./images/part4-fleet-in-action-pg0.png)

![Rancher UI](./images/part4-fleet-in-action-pg1.png)

![Rancher UI](./images/part4-fleet-in-action-pg2.png)

Now let try to open the Application in a new Browser window

Go the `Services` Tab to expose the Container Application.

illustration below, show our applivation version  `spring-petclinic:v1.0.x` as indicated in previous step.

![Rancher UI](./images/part4-fleet-in-action-Cluster1-Services-Open-App-pg1.png)

![Rancher UI](./images/part4-fleet-in-action-Cluster1-Services-Open-App-pg2.png)

With this, let's put everything together and proceed to [Part 5](part-5.md)



