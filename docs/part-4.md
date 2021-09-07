# Part 4 - Integrating Jenkins pipeline with Rancher

Watch the video to understand what you are going to do in part 4:

[![Workshop Part 4](https://img.youtube.com/vi/cjPNjb9e8NI/0.jpg)](https://www.youtube.com/watch?v=cjPNjb9e8NI)

## Rancher Continous Delivery (CD)

Before you configure Rancher Continous Delivery, please open and login to the following 
1) Jenkin UI
2) Harbor UI
3) Rancher UI
4) Cluster Explorer view for `Cluster1` and `Cluster2`.

### Configure Rancher Continous Delivery (CD)

1) Rancher UI > Cluster Manager View select `Tools` and click on `Continous Delivery`

![Rancher-Continous Delivery (CD)](./images/rancher-uI-fleet-step1-pg1.png)

Before we proced, let's verify if we can see all our cluster in Continous Delivery

![Rancher-(CD)](./images/rancher-uI-all-clusterlist-step2.png)

With Rancher Continous Delivery, one can manage individual or group of clusters. Managing cluster via Group reduces adminstrative efforts. 

### Create a Cluster Group
1) Navigate to `Cluster Group` and click on `Create`. Give it a name `development`

![Rancher UI](./images/rancher-ui-create-first-fleet-group-step3-pg3.png)

Here we are going to use the same Label which was used to create `Cluster1` and `Cluster2`.

2) Under Cluster Selector provide the following values
Key:`env`
Operator: `=`
Value:`dev` 
 
Once you key in the key:value pair, Rancher will use the selector labels to indentify the clusters to be associated with our newly created cluster group in Fleet. You will see it show 2/4 cluster been selected. 

![Rancher UI](./images/rancher-ui-create-first-fleet-group-details-step4-pg4.png)

3) Click on `Create` which will create our first Cluster Group.

![Rancher UI](./images/rancher-ui-first-fleet-group-success-step5-pg5.png)

### Configure Git Repo

Before we ahead for configuring the Git Repo, we need to Git Repository URL.

Follow the instruction below to get to Git Repository URL.

1) Login into GitHub account
2) Search for the repository named `spring-petclinic-helmchart` 
3) Click on the Repository URL and you will be taken into the `code` tab. In the code tab, you will be in the `main` branch.
4)  Click on `code` tab, use the drop down menu and you will be presented with the repositroy url. 
5) Click on the clipboard icon to copy the URL from `HTTPS` tab. 

Sample below for reference. 

![Rancher UI](./images/part4-configure-git-repo-forked-url.png)

6) In Rancher UI > Continous Delivery > Git Repos, click on `Create`
a) Give a name to your Git Rep `Name`
b) Paste the Git Repo URL in `Repository URL`  
c) In the Branche Name type `main` 
d) Use the dropdown option and select the Cluster Group we created previosuly `development`. 
e) Provide a Namespace `spring-petclinic`

Sample output of the GitRepo configuration below

![Rancher UI](./images/part4-configure-git-repo-config.png)

Since the pipeline is in progess while you are configuring Fleet, we expect the below output 

![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-1.png)

Our Rancher Contious Delivery configuration is completed. 

## 2. View Jenkins Pipeline Progess and Rancher Continous Delivery in action.

Just to set the context here, you may see slightly different progress/view, based on which stage of the pipeline.

Below are sample display for your reference only. 

For easy viewing, you can split the screen (Horizontal/Veritcal) as per your preference to observe the progress. 

### Jenkins Container creation stage
![Rancher UI](./images/part4-configure-git-repo-status-while-pipeline-in-progress-2.png)

### Jenkins approval stage.

At one time in the pipeline, you will get to the `Approval stage`, where you will be prompted to `Approve` or `Decline` the changes. 

Upon approval, jenkins commits the changes to Git Repo. The container image will be stored in your Harbor Registry.

You can toggle Harbor UI > Library > Repoistory where you will see our application container image available.

![Rancher UI](./images/part4-configure-git-repo-status-pipeline-in-progress-container-created-in-harbor-pg4.png)

### Rancher Continous Delivery in Action

Rancher Continous Delivery is configured for a `Git Repo` and a branch in our case `main` branch to watch for changes/commits. Racher CD will picked up the changes and ensure the deploy the bundles in the target cluster group

Fleet Update is successfully completed.
![Rancher UI](./images/part4-fleet-in-action-pg0.png)

In Rancher UI, on either `Cluster1` or `Cluster2` you should see our Spring PetClinic Container running. Take a closer look at the version, it should say `spring-petclinic:v1.0.x`.

![Rancher UI](./images/part4-fleet-in-action-pg1.png)

![Rancher UI](./images/part4-fleet-in-action-pg2.png)

Now let try to open the Application in a new Browser window
Rancher UI > Cluster Exlporer > Cluster1 > `Services` Tab to expose the Container Application.

![Rancher UI](./images/part4-fleet-in-action-Cluster1-Services-Open-App-pg1.png)

Check our applivation version  `spring-petclinic:v1.0.x` as indicated in previous step.

Image below illustrate JenkinUI, Rancher UI & Application in a new browser window.

![Rancher UI](./images/part4-fleet-in-action-Cluster1-Services-Open-App-pg2.png)

With this, let's put everything together and proceed to [Part 5](part-5.md)

