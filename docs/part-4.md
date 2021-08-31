# Part 4 - Rancher Fleet - Continous Delivery 

## 1. Provision all-in-one RKE clusters on VM (cluster1 and cluster2)

Open browser to navigate to the Rancher URL captured in earlier steps. Authenticate by providing your Rancher credentials.

You will now be navigated to Rancher Cluster Management UI. Click `Add Cluster` button to create new kubernetes cluster with RKE and existing bare-metal servers or virtual machine `Existing Node` option. 

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster1-pg1-latest.png)


Enter the cluster name as `cluster1`, Under `Labels & Annotation` field, add Label with key value pair `env` and `dev`. Leave the rest of the setting as default and click `Next` button. 

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster1-pg2-latest.png)

You will be prompted with a command to setup RKE on your VM. Click the `copy` icon to copy the command into your clipboard.

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster1-pg3-latest.png)

On your linux terminal, execute the below script to access your cluster1 terminal 

Copy the script below to ssh into the cluster1 
```
./ssh-mylab-cluster1.sh
```
Copy & paste the command from Rancher UI on the terminal of VM - Cluster1.

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster1-pg4-latest.png)

On Rancher UI, you will see cluster 1 coming in few mins. 

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster1-pg5-latest.png)

Cluster 1 is successfully provision in Rancher

### 2. Provision all-in-one RKE cluster on VM (cluster2)

Repeat all step from step1 for adding cluster 2
Make sure you name the cluster as `Cluster2`

![Rancher UI](./images/rancher-add-cluster-new-cluster-existing-node-Cluster2-pg1-latest.png)

### 3. Configure Rancher Fleet - Continous Delivery

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

Before we ahead for configuring the Git Repo, we need to Git URL.

Follow the instruction below to get to Git URL.

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

Rest all default.

Sample output of the GitRepo configuration

![Rancher UI](./images/part4-configure-git-repo-config.png)

With this, let's put everything together and proceed to [Part 5](part-5.md)


Note:
PetClinic Helm Chart URL as opposed to PetClinic repo.
Pod  - Container Creation, 
Add the cluster 1 & 2 with Public & Internal IP assigned
Configure Services for App using Node port 30800 as it coded in the app logic 



