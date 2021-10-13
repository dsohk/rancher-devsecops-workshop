
# Part 1 - Build Your Lab Environment on AWS Lightsail

This script will help you setup a lab environment with 8 VMs running on AWS Lightsail.

Estimated Completion Time: 45 mins

* Rancher Management Server v2.6.1 instance (1 VM)
* Harbor private registry running on K3S (1 VM)
* DevSecOps RKE2 cluster running `Jenkins`, `Anchore`, and `SonarQube` (3 VM - 1 master + 2 worker nodes)
* 2 single-node RKE2-based clusters (1 VM each) for deploying applications.

## Pre-requisites

* Github account
* AWS account with AWS Lightsail full admin access
* Linux workstation with `git` and `aws` command line v2 installed and AWS credential key configured.

## See Part 1 in Action

Watch the video below to see what we are going to do in this part.

[![Workshop Part 1](https://img.youtube.com/vi/NuNhrw6JDTU/0.jpg)](https://www.youtube.com/watch?v=NuNhrw6JDTU)

## To build the lab on AWS Lightsail

### 1. Clone Git Repository

1) In your linux terminal, create a folder for the workshop and  checkout this repository into a local folder.

```
mkdir workshop
```

```
git clone https://github.com/dsohk/rancher-devsecops-workshop workshop
```

2) To view the content for the Cloned Repo, in your terminal execute below command
```
cd ~/workshop && ll 
```
you should see below sample outout. 
```
dpatel@dns:~> cd ~/workshop/rancher-devsecops-workshop && ll
total 40
-rwxr-xr-x 1 dpatel users  831 Sep 30 15:25 cleanlab.sh
drwxr-xr-x 1 dpatel users  120 Sep 30 15:25 docs
-rw-r--r-- 1 dpatel users 1065 Sep 30 15:25 LICENSE
-rw-r--r-- 1 dpatel users 1226 Sep 30 15:25 README.md
drwxr-xr-x 1 dpatel users  188 Sep 30 15:25 setup
-rwxr-xr-x 1 dpatel users  999 Sep 30 15:25 setup-rke-cluster1.sh
-rwxr-xr-x 1 dpatel users  999 Sep 30 15:25 setup-rke-cluster2.sh
-rwxr-xr-x 1 dpatel users 1846 Sep 30 15:25 setup-rke-devsecops.sh
-rwxr-xr-x 1 dpatel users 1014 Sep 30 15:25 show-mylab-env.sh
-rwxr-xr-x 1 dpatel users 8470 Sep 30 15:25 startlab.sh
```

### 2. Deploy VMs on AWS Lightsail and Setup Rancher Management Server

Run the `startlab.sh --help` to get list of options. You should see the output like below.

```
❯ ./startlab.sh --help
  ___ _   _ ___ ___   ___              _
 / __| | | / __| __| | _ \__ _ _ _  __| |_  ___ _ _
 \__ \ |_| \__ \ _|  |   / _` | ' \/ _| ' \/ -_) '_|
 |___/\___/|___/___| |_|_\__,_|_||_\__|_||_\___|_|


Welcome to SUSE Rancher DevSecOps Hands-on Lab on AWS Lightsail ...
This script will help you to provision VMs on AWS Lightsail to get started to run your lab exercise. By default, this script will install Rancher for you after VM is up.

usage: ./startlab.sh [options]
-s    | --skip-rancher              Skip deploying Rancher after VM is up.
-h    | --help                      Brings up this menu

```

1) Run `startlab.sh` to deploy VMs on AWS Lightsail and automatically setup Rancher management server. It will prompt you which AWS region you would like to run your lab. 

```
./startlab.sh
```

2) You will be prompted to choose which AWS Environment and region you are going to run your lab environment.

```
dpatel@dns:~/workshop/rancher-devsecops-workshop> ./startlab.sh 
  ___ _   _ ___ ___   ___              _            
 / __| | | / __| __| | _ \__ _ _ _  __| |_  ___ _ _ 
 \__ \ |_| \__ \ _|  |   / _` | ' \/ _| ' \/ -_) '_|
 |___/\___/|___/___| |_|_\__,_|_||_\__|_||_\___|_|  
                                                    

Welcome to SUSE Rancher DevSecOps Hands-on Lab on AWS Lightsail ...
This script will help you to provision VMs on AWS Lightsail to get started to run your lab exercise. By default, this script will install Rancher for you after VM is up.

usage: ./startlab.sh [options]
-s    | --skip-rancher              Skip deploying Rancher after VM is up.
-h    | --help                      Brings up this menu

Checking pre-requisites...
git installed
awscli v2 installed

Select Your Preferred AWS Environment to run your lab:
1) US/Canada
2) Europe
3) Asia
4) Quit
 3
Asia 
Select regions
1) Mumbai
2) Seoul
3) Singapore
4) Sydney
5) Tokyo
6) Quit

 1
You picked: Mumbai
Provisioning VM in your AWS Lightsail region ap-south-1 as lab environment ...
```

Choose the region closest to you to continue your lab setup. The script will then
a) Provision VMs on your AWS account with region you picked, 
b) Configure firewall rules for these VMs, 
c) Download AWS SSH keypair to your local folder to access to these VMs, and
d) Create shortcut files for you to access to the VMs in your lab environment.
e) Install Kubernetes tools (`Kubectl` & `helm`)
f) Deploy Rancher using Docker

#### Incase if you experience Error creating AWS Lighsail instance

Possible error `An error occurred (InvalidInputException) when calling the CreateInstances operation: We're sorry, your AWS account is pending verification. Please try again later`

Resolution - 
Perform cleanup by executing the below script. 
```
./cleanlab.sh
```
Post the cleanup re-run the startlab.sh script.

When the script has finished, you will see a table of VMs with IP addresses, the Rancher instance URL, and other useful files created in your local folder. For example, this is the extract of my output after running the startlab script.

*The IP addresses for you will be different from those in the screenshots in this lab guide.*

```
---------------------------------------------------------------------------
Your Rancher Server is ready.

Your Rancher Server URL: https://rancher.13.232.154.67.sslip.io
Bootstrap Password: 4rfkljvwb6ldbplfgfjg6tppwggbsq56mgl9npntltn4qpc6dhv9nf
----------------------------------------------------------------------------
Your lab environment on AWS Lightsail ap-south-1 is ready. 

Here's the list of VMs running in your lab environment (See file: mylab_vm_list.txt):
-----------------------------------------------------------------------------
|                               GetInstances                                |
+-----------------------+--------------------+-------------------+----------+
|        VMname         | privateIpAddress   |  publicIpAddress  |  state   |
+-----------------------+--------------------+-------------------+----------+
|  suse0908-cluster2    |  172.26.31.243     |  65.2.78.40       |  running |
|  suse0908-devsecops-m1|  172.26.28.50      |  13.126.78.17     |  running |
|  suse0908-cluster1    |  172.26.19.112     |  15.207.115.122   |  running |
|  suse0908-devsecops-w2|  172.26.0.206      |  13.235.134.68    |  running |
|  suse0908-harbor      |  172.26.31.128     |  65.0.177.135     |  running |
|  suse0908-devsecops-w1|  172.26.20.135     |  3.109.200.216    |  running |
|  suse0908-rancher     |  172.26.26.107     |  13.232.154.67    |  running |
+-----------------------+--------------------+-------------------+----------+
To SSH into the VM on the lab, you can run this command:

./ssh-mylab-<vm>.sh


```
Save the Rancher Server URL and Bootstrap Password for the next steps.

3) Open the Rancher URL in a browser window. This may take few mins to get Rancher Instance up and running. 

4) Toggle back to the terminal and execute the below command to see the list of files (text and scripts).

```
ls -lh 

```
Sample output below.

```
dpatel@dns:~/workshop/rancher-devsecops-workshop> ll
total 104
-rwxr-xr-x 1 dpatel users  831 Sep 30 15:25 cleanlab.sh
drwxr-xr-x 1 dpatel users  120 Sep 30 15:25 docs
-rw-r--r-- 1 dpatel users 1065 Sep 30 15:25 LICENSE
-rw-r--r-- 1 dpatel users   29 Sep 30 15:53 mylab_aws_region.sh
-rw------- 1 dpatel users 1676 Sep 30 15:54 mylab.key
-rw-r--r-- 1 dpatel users  381 Sep 30 15:54 mylab.pub
-rw-r--r-- 1 dpatel users   34 Sep 30 15:53 mylab_rancher_version.sh
-rw------- 1 dpatel users  654 Sep 30 15:54 mylab-ssh-config
-rw-r--r-- 1 dpatel users 1043 Sep 30 15:54 mylab_vm_list.txt
-rw-r--r-- 1 dpatel users   26 Sep 30 15:53 mylab_vm_prefix.sh
-rw-r--r-- 1 dpatel users 1226 Sep 30 15:25 README.md
drwxr-xr-x 1 dpatel users  188 Sep 30 15:25 setup
-rwxr-xr-x 1 dpatel users  999 Sep 30 15:25 setup-rke-cluster1.sh
-rwxr-xr-x 1 dpatel users  999 Sep 30 15:25 setup-rke-cluster2.sh
-rwxr-xr-x 1 dpatel users 1846 Sep 30 15:25 setup-rke-devsecops.sh
-rwxr-xr-x 1 dpatel users 1014 Sep 30 15:25 show-mylab-env.sh
-rwxr-xr-x 1 dpatel users   67 Sep 30 15:54 ssh-mylab-cluster1.sh
-rwxr-xr-x 1 dpatel users   69 Sep 30 15:54 ssh-mylab-cluster2.sh
-rwxr-xr-x 1 dpatel users   69 Sep 30 15:54 ssh-mylab-devsecops-m1.sh
-rwxr-xr-x 1 dpatel users   67 Sep 30 15:54 ssh-mylab-devsecops-w1.sh
-rwxr-xr-x 1 dpatel users   66 Sep 30 15:54 ssh-mylab-devsecops-w2.sh
-rwxr-xr-x 1 dpatel users   55 Sep 30 15:54 ssh-mylab-devsecops-w3.sh
-rwxr-xr-x 1 dpatel users   55 Sep 30 15:54 ssh-mylab-devsecops-w4.sh
-rwxr-xr-x 1 dpatel users   66 Sep 30 15:54 ssh-mylab-harbor.sh
-rwxr-xr-x 1 dpatel users   66 Sep 30 15:54 ssh-mylab-rancher.sh
-rwxr-xr-x 1 dpatel users 8470 Sep 30 15:25 startlab.sh

```

You can access to any of your VMs with the `ssh-mylab-<VM>.sh` script. The IP addresses of your VMs are also captured in the file `mylab_vm_list.txt`

### 3. Setup Harbor instance and Import into Rancher 

#### 3.1 Setup Harbor Registry

We will be using Harbor as our Private Registry

While we are waiting Rancher Server instance to be ready, let's setup your harbor private registry.

The script will,   
a) Provision K3s cluster.
b) Deploying Harbor (using Helm Chart v1.7.2 & App v2.3.2) on K3s.
c) Configure Harbor CA cert locally 
d) Downloading Docker Images for Maven, Java Libaries for Maven and Sles15sp3-openjdk and importing them into Harbor. 

a) Login to your harbor instance VM with SSH from your linux workstation.

```
./ssh-mylab-harbor.sh
```
Sample output below indicates you are on Harbor VMs Terminal.

```
dpatel@dns:~/workshop/rancher-devsecops-workshop> ./ssh-mylab-harbor.sh
openSUSE Leap 15.2 x86_64 (64-bit)

As "root" use the:
- zypper command for package management
- yast command for configuration management

Have a lot of fun...
suse0908-harbor ec2-user@ip-172-26-22-139:~>

```
b) On the Harbor VMs Terminal, run the script below to automatically setup harbor private registry on K3S in this VM instance.

```
./99-one-step-install-harbor.sh
```
Sample output below show Harbor URL and Admin User credentials. 

**Please do NOT change the harbor login credential as the lab assumes to use the randomly generated strong password throughout the rest of the setup**.

```
============================================================
Congrats! Your Harbor instance has been setup successfully.
URL: https://54.153.196.73:30443
User: admin
Password: J4diXo8ZKddi5mFGEgx1Z3XveoOuPw
```
c) Open Harbor URL in a browser and log into Harbor using credentials provided as in sample output 

#### 3.2 Import Harbor cluster in Rancher.

In this step, we would be importing Harbor K3s cluster into Rancher. 

a) You should be logged into `Harbor VM` for this, incase if your terminal timeout or for any reason you are not on Harbor VMs, please execute the script below which will automtically take you to the Harbor VMs Terminal.
```
./ssh-mylab-harbor.sh
```
b) Open browser to navigate to the Rancher URL captured in earlier step.

Sample output
```
Your Rancher Server URL: https://rancher.13.232.154.67.sslip.io
Bootstrap Password: 4rfkljvwb6ldbplfgfjg6tppwggbsq56mgl9npntltn4qpc6dhv9nf
```
By pass the invalid SSL certificate warning, you should be prompted a `Welcome to Rancher` page. 
Provide the bootstrap password generated during setup. Hit `Log in with Local User`

![Rancher UI](./Images-10-13-2021/part1-step3-3-1-rancher-ui-welcome-rancher-using-bootstrapp-password-pg1.png)

Following page will be presented with 
a) You can setup your own administrative password  by selecting `Set a specific password to use`
b) You will be presented with Rancher URL
Accept the Terms and Conditions

![Rancher UI](./Images-10-13-2021/part1-step3-3-rancher-ui-change-rancher-password-post-initial-login-and-rnacher-url-pg2.png)

Finally you will be presented with the Rancher Homepage

![Rancher UI](./Images-10-13-2021/part1-step3-3-rancher-ui-rancher-homepage-pg3.png)

3) Import Harbor cluster
a) On Rancher Homeage, click on `Import Cluster` to import a existing cluster with `Generic` option.

![Rancher UI](./Images-10-13-2021/part1-step3-4-1-rancher-import-cluster-harbor-pg1.png)

![Rancher UI](./Images-10-13-2021/part1-step3-4-2-rancher-import-cluster-harbor-pg2.png)

b) Enter the custer name as `harbor` and leave the rest of the setting as default & click on `Create`. 

![Rancher UI](./Images-10-13-2021/part1-step3-4-3-rancher-import-cluster-Harbor-pg3.png)

c) You will be prompted with a set of commands. 
Last command which says `Rancher installation has self signed trusted SSL certificate`, copy the command and paste the command on the Harbor VMs Terminal to import the cluster. 

![Rancher UI](./Images-10-13-2021/part1-step3-4-4-rancher-import-cluster-harbor-using-self-signed-certificate-pg4.png)

Incase if you see below messages, 
```
error: no objects passed to apply
```
Re-run the command again using the Up arrow key from keyboard.

![Rancher UI](./Images-10-13-2021/part1-step3-4-5-rancher-import-cluster-harbro-running-rancher-command-on-harbor-vm-pg5.png)

d) You can now toggle to Rancher UI and should find Harbor Cluster successfully imported

![Rancher UI](./Images-10-13-2021/part1-step3-4-6-rancher-import-harbor-success-rancher-ui.png)


### 4. Provision DevSecOps RKE cluster from Rancher UI

In this step, we will be provisioning RKE cluster with One Master & Two worker Nodes along with thier Private, Public and Node names along with thier role. We have scripted this process to match the lab requirement. 

In the following step, we will add `devsecops` cluster in Rancher.

a) Navigated to Rancher Cluster Management UI. Click `Create` button. 

![Rancher UI](./Images-10-13-2021/part1-step4-0-rancher-ui-create-custom-cluster-devsecops-pg0.png)

You will be presented `Cluster:Create` page. 

Under section `Provision a new node and create a cluster using RKE2/K3s (Tech Preview)`, toggle the switch `RKE2/k3s`. With Rancher 2.6 you can now provisoin RKE2 & K3s cluster via Rancher UI.

To create a new cluster choose the `custom` option to provision clusters on existing nodes 

![Rancher UI](./Images-10-13-2021/part1-step4-1-rancher-ui-create-cluster-custom-devsecops-pg1.png)

b) You will be presented with `Cluster:Create Custom`form. Enter the cluster name as `devsecops` and leave the rest of the settings as default and click `Create` button. You will be presented with cluster registration command to create the RKE cluster on your VM. Check the box 'Insecure: Select this to skip TLS...'. 
Click on `registration command` to copy the command into your clipboard.

![Rancher UI](./Images-10-13-2021/part1-step4-2-rancher-ui-create-cluster-custom-devsecops-pg2.png)

![Rancher UI](./Images-10-13-2021/part1-step4-3-rancher-ui-create-cluster-custom-devsecops-pg3.png)

c) Open your Linux workstation terminal and switch to the working directory where this repo has been checked out. 

Run the script `./setup-rke-devsecops.sh` and paste the command you copied into the prompt from this script.

```
./setup-rke-devsecops.sh
```
```
❯ ./setup-rke-devsecops.sh
Enter Rancher registration command for devsecops cluster:
```
Sample output below


![Rancher UI](./Images-10-13-2021/part1-step4-4-copy-n-paste-devsecops-build-command-pg4.png)

d) Return to your browser with Rancher UI, you should see the `devsecops` cluster is being initialized. It may take 5-10 minutes to complete the whole RKE cluster setup.

While the devsecops cluster is being provisioned, you can continue with step 5 for provisioning additional RKE clusters.

![Rancher UI](./Images-10-13-2021/part1-step4-5-rancher-ui-devsecops-pg5.png)

Cluster Explorer View for details

![Rancher UI](./Images-10-13-2021/part1-step4-6-rancher-ui-devsecops-cluster-explorer-dashboard-view-pg6.png)


### 5. Provision additional RKE Clusters 
In this steps, we will be provisioning two single node RKE cluster with Etcd, Control Plane & worker all 3 components, co-existing on single node hence called (All-in-One) RKE Cluster. 

#### All-In-One RKE clusters 

a) Ensure you are on your local workstation/machine Terminal and inside your git repo cloned.

```
cd ~/workshop
```
b) At the terminal, run the below script. 

```
./setup-rke-cluster1.sh
```
The Terminal will be seeking input command to create the cluster. The command for creating the cluster will be generate in the following step below.

c) Navigate to Rancher Cluster Management UI, click `Create`

![Rancher UI](./Images-10-13-2021/part1-step5-1-create-custom-all-in-1-rke2-cluster-pg1.png)

You will be presented with `Cluster:Create` form. To create a new cluster, choose `Custom`to provision cluster using RKE2/K3s on existing node.

![Rancher UI](./Images-10-13-2021/part1-step5-2-rancher-ui-create-cluster-custom-all-in-1-rke2-cluster-pg2.png)

In `ClusterName` type `cluster1`
Under `Cluster Configuration` `Basics` form leave everthing as default. 

![Rancher UI](./Images-10-13-2021/part1-step5-3-rancher-ui-create-cluster-custom-all-in-1-rke2-cluster-pg3.png)

In `Labels & Annotation` tab, under `Labels`, provide the key:vaue pair. In `Key` type `env` and  `Value` type `dev` and hit `Create`

![Rancher UI](./Images-10-13-2021/part1-step5-4-rancher-ui-create-cluster-custom-all-in-1-rke2-cluster-pg4.png)

You will be presented with `Registration` tab. Check the box 'Insecure: Select this to skip TLS...'. 
Click on the command to copy. 

![Rancher UI](./Images-10-13-2021/part1-step5-5-rancher-ui-create-cluster-custom-all-in-1-rke2-cluster-copy-command-pg5.png)

Paste the registration command on your terminal to start the cluster build process. 

![Rancher UI](./Images-10-13-2021/part1-step5-6-cluster1-terminal-copy-n-paste-create-cluster1-command-pg6.png)

![Rancher UI](./Images-10-13-2021/part1-step5-7-cluster1-terminal-copy-n-paste-create-cluster1-command-pg7.png)

d) Toggle to Rancher UI to veiw the newly registered `cluster1`

![Rancher UI](./Images-10-13-2021/part1-step5-8-rancher-ui-cluster1-success-pg8.png)

#### Provision additional RKE Cluster, All-In-One RKE clusters `Cluster2`

We are currently on the local workstation Terminal where we have our git repo cloned.

Sample output below.
```
dpatel@dns:~/workshop>
```
1) At the terminal, run the below script 
```
./setup-rke-cluster2.sh
```

2) Repeat the step a, to d from previous section. 

Two important things to note

a) Cluster name will be `cluster2`. 
b) In `Labels & Annotation` tab, under `Labels`, provide the key:vaue pair. In `Key` type `env` and  `Value` type `dev`. 
Check the 'Insecure: Select this to skip TLS...'.

c) Finally we should see both clusters `cluster1` and `cluster2` visible in Rancher.

![Rancher UI](./Images-10-13-2021/part1-step5-10-rancher-ui-cluster2-success-pg10.png)


### 6. Download KUBECONFIG file of DevSecOps cluster into Harbor VM
a) In Rancher UI > Global Apps > Cluster Management > `devsecops`, hit the `Explore` button.

![Rancher UI](./Images-10-13-2021/part1-step6-devsecops-kubeconfig-pg1.png)

b) In the devsecops cluster, toward the righthand corner look for `file` like icon. Click on it and it would download the KubeConfig file.

![Rancher UI](./Images-10-13-2021/part1-step6-devsecops-kubeconfig-pg2.png)

c) On your linux workstation, ssh into your harbor VM by executing the script `ssh-mylab-harbor.sh` script). 

```
./ssh-mylab-harbor.sh
```
d) Create a file `devsecops.cfg` under `~/.kube` folder.

```
vi ~/.kube/devsecops.cfg
```
e) Open the downloaded `KubeConfig` file which should be in download folder & paste the KubeConfig content. Save and exit.

f) If you see the below sample message 

`Kubernetes configuration file is group-readable. This is insecure. Location: /home/ec2-user/.kube/devsecops.cfg`

Modify the file permission by removing additional permissions.

```
chmod 600 ~/.kube/devsecops.cfg
```
g) Configure Kubernetes client to use this kubeconfig file. 

```
export KUBECONFIG=~/.kube/devsecops.cfg
```

h) Verify if it can connect to your devsecops cluster. If you see an output like below, you are good.

```
kubectl get nodes
```
Sample output below

![Rancher UI](./Images-10-13-2021/part1-step6-devsecops-kubeconfig-working-pg3.png)

### 7. Install Longhorn on DevSecOps Cluster

1) If you are not already logged into Harbor VM then run the script `ssh-mylab-harbor.sh` script), else skip to step 2 

```
./ssh-mylab-harbor.sh
```

2) Type the below command to deploy Longhorn 

```
cd devsecops/longhorn
./99-one-step-install-longhorn.sh
```
You should see below output with successfully deployment of Longhorn

![Rancher UI](./Images-10-13-2021/part1-step7-longhorn-success-pg1.png)

3) In Rancher UI > Global Apps > Cluster Management > `devsecops` > Explore > `Longhorn` 

![Rancher UI](./Images-10-13-2021/part1-step7-rancher-ui-longhorn-pg2.png)

![Rancher UI](./Images-10-13-2021/part1-step7-rancher-ui-longhorn-url-pg3.png)

![Rancher UI](./Images-10-13-2021/part1-step7-rancher-ui-longhorn-ui-pg4.png)


### 8. Deploy Jenkins, Anchore and Sonarqube on devsecops RKE cluster from Harbor VM

In our final step for part 1, we are going to deploy the following in parallel.

* Jenkins (approx 5 mins)
* Anchore (approx 3/4 mins)
* Sonarqube (approx < 6 mins)

1) If you are not already logged into Harbor VM then run the script `ssh-mylab-harbor.sh` script, else skip to step 2 

```
./ssh-mylab-harbor.sh
```
2) Open two additional terminals, as we will run the deployment of Jenkins, Anchore & Sonarqube one after.

![Deploy Jenkins and others](./Images-10-13-2021/deploy-jenkins-and-others-start.png)

3) In terminal 1 of your Harbor VM, run the following command to setup Jenkins.

```
cd ~/devsecops/jenkins
./99-one-step-install-jenkins.sh
```
This should take a while to build Jenkins along with required plugin of our choice to be built in `devsecops` cluster.

![Deploy Jenkins and others](./Images-10-13-2021/Part1-Step8-1-Jenkins-url-&-credentials-pg1.png)

In Rancher UI > Global Apps > Cluster Management > `devsecops` > Explore > `Workload` > `Pods` 

![Deploy Jenkins and others](./Images-10-13-2021/part-step8-2-rancher-ui-jenkins-success-pg2.png)

![Deploy Jenkins and others](./Images-10-13-2021/part-step8-3-rancher-ui-jenkins-success-pg3.png)

Since Jenkins is up and running, you can now open your browser and login to Jenkins system using the credentials available.

![Deploy Jenkins and others](./Images-10-13-2021/jenkins-homepage.png)


#### Here's a high level view of what has been accomplished so far...

a) Deployment & configuration of self signed certificate with Harbor. Self Signed Certificated are distributing to all Labs VMs. With help of Docker Client, we are able to login in the VM using self signed certifiate. 

b) Pulling Jenkins Image, building custom Jenkins image with own choise of plugins for this lab and adding it to Harbor registry.

c) Provisioning Jenkins using Helm Chart

d) Configuring Jenkins GitHub webhook



4) In Terminal 2 of Harbor VM, run the following command to setup Anchore 

```
cd ~/devsecops/anchore
./99-one-step-install-anchore.sh
```
![Deploy Jenkins and others](./Images-10-13-2021/part-step8-6-anchore-url-n-credentials-pg6.png)

In Rancher UI > Global Apps > Cluster Management > `devsecops` > Explorer > `Workload` > `Pods` 

![Deploy Jenkins and others](./Images-10-13-2021/part-step8-5-rancher-ui-anchore-success-pg6.png)

It will also take a while to deploy anchore on your devsecops cluster. Likewise, let's continue our lab to deploy Sonarqube.

**Important: Anchore community edition does not have GUI & hence no URL to login**.


5) On Terminal 3 on Harbor VM, run the following command to setup Sonarqube.

```
cd ~/devsecops/sonarqube
./99-one-step-install-sonarqube.sh
```
![Deploy Jenkins and others](./Images-10-13-2021/part-step8-7-sonarqube-url-n-credentials-pg7.png)

In Rancher UI > Global Apps > Cluster Management > `devsecops` > Explore > `Workload` > `Pods` 

![Deploy Jenkins and others](./Images-10-13-2021/part-step8-8-rancher-ui-sonarqube-success-pg8.png)

Since Sonarqube is up and running, you can now open your browser and login to Sonarqube using the credentials available. You might need to setup a new password.

![Deploy Jenkins and others](./Images-10-13-2021/sonarqube-homepage.png)

With this, we have successfully completed all required steps in Part 1. We are ready to move to the Part 2 [Step 2 - Configure GitHub and Jenkins](part-2.md)

