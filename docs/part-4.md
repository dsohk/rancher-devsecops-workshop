# Part 4 - Rancher Fleet - Continous Delivery 

## 1. Configure Rancher Fleet - Continous Delivery

To setup Fleet, from Rancher UI, Cluster Manager Page select `Tools` and click on `Continous Delivery`

![Rancher-Continous Delivery (CD)](./images/rancher-uI-fleet-step1-pg1.png)

Before we go any further, let verify if we can see all our cluster in Rancher FLeet

![Rancher-(CD)](./images/rancher-uI-all-clusterlist-step2.png)

In Fleet you can manage indivisual or group of clusters. Managing cluster via Group reduces adminstrative efforts. 

To create Cluster Group in Continous Delivery, click on Cluster Groups option in left plane & hit `Create`

![Rancher UI](./images/rancher-ui-create-first-fleet-group-step3-pg3.png)

Provide unique `Name` for cluster group and in `Cluster Selector` section, provide same Label key value pair which was used to create `Cluster1` and `Cluster2`

Key:Value `(env=dev)` 

Once you key in the key:value pair, Rancher will use the selector labels to indentify the clusters to be associated with our newly created cluster group in Fleet. You will see it show 2/4 cluster been selected. 

![Rancher UI](./images/rancher-ui-create-first-fleet-group-details-step4-pg4.png)

Hit `Create` which will create our first Cluster Group.

![Rancher UI](./images/rancher-ui-first-fleet-group-success-step5-pg5.png)

Once our Cluster Group is created, we then need to define a Git Repo for Fleet.

#### 4. Configure Git Repo

Before we ahead for configuring the Git Repo, we need to Git Repository URL.

Follow the instruction below to get to Git Repository URL.

Open you GitHub. You will find your repository on left hand side of the page. If you still not able to find, use the search option and specify the repository name `spring-petclinic-helmchart` 

Click on the Repository URL and you will be taken into the `code` tab. 

In the code page, you will be in the `main` branch & you will see `code` tab. Click on the drop down menu of Code tab and you will be presented with the repositroy url. Click on the clipboard icon to copy the URL from `HTTPS` tab. 

Sample below for reference. 

![Rancher UI](./images/part4-configure-git-repo-forked-url.png)

We are not ready to Configure our Git Repo

To configure Git Reop, click on `Create` in Git Repos page in Continous Delivery. Provide details to complete the form page.  

Name: 

Repository URL: `https://github.com/<github-id>/spring-petclinic-helmchart.git`

Branch Name: NOTE Branche Name is `main` and not `master`

Deploy To: Cluster/Cluster Group. In my case `development`


Branch Name: Note Branche Name is `main` in our case & not `master`

Deploy To - 

Target Namespace: `spring-petclinic`

Rest all default and hit `Create`

Sample output of the GitRepo configuration

![Rancher UI](./images/part4-configure-git-repo-config.png)

Since the pipeline is in progess while you are configuring Fleet, we expect the below output 

![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-1.png)

Side by Side view of Jenkins Pipeline & Rancher CD (Fleet)
![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-2.png)


At one point in pipline we will reach the approval stage to commit the code to the GitHub Repo (Forked on in our personal Github) 

![Rancher UI](./images/part4-configure-git-repo-approval-stage.png)


![Rancher UI](./images/part4-fleet-in-action.png)



part4-configure-working-Fleet-1
With this, let's put everything together and proceed to [Part 5](part-5.md)


Note:
PetClinic Helm Chart URL as opposed to PetClinic repo.
Pod  - Container Creation, 
Add the cluster 1 & 2 with Public & Internal IP assigned
Configure Services for App using Node port 30800 as it coded in the app logic 



