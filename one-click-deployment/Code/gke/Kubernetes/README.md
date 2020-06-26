# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster), containing
Terraform configuration files to provision an GKE cluster on
GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

## Install and configure GCloud

First, install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/quickstarts) 
and initialize it.

```shell
$ gcloud init
```

## few gcloud commands for understanding

```shell
gcloud help
gcloud version
gcloud components list
gcloud init
gcloud auth list
gcloud info
gcloud projects list  
gcloud config get-value project
gcloud config set project <project name>
gcloud config configurations list
gcloud compute instances list
gcloud compute networks list
gcloud compute networks subnets list
gcloud compute networks subnets list --network <vpc-name>
gcloud compute networks create <vpc-name> --description "new vpc" --subnet-mode custom
```

In Google console create a service account under the project and provide required access (owner/editor of the project) and generate the key
Save that key in json format.

Export the key location to environmental variables as below:
```shell
$ export GOOGLE_APPLICATION_CREDENTIALS = "<path of the json file>
```
## Initialize Terraform workspace and provision GKE Cluster


you can find a full list of gcloud regions [here](https://cloud.google.com/compute/docs/regions-zones).

By initializing the terraform, it will prompt for the below value to enter. Example values are provided in the description of each variable

``` list
credentials     --> Absolute path to key file in JSON format. Ex: /home/user/gcpkey/project-123.json (without Quotes).
project_id      --> The ID of the project in which the resources belong.
gcp_location    --> The location (region or zone) in which the cluster master will be created. Ex: us-central1 or us-central1-a
initial_node_count  --> Number of initial nodes to create. (only numbers)
min_node_count  --> Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count. (only numbers)
max_node_count  --> Maximum number of nodes in the NodePool. Must be >= min_node_count. (only numbers)
machine_type    --> Type of machine for nodes- Ex: n1-standard-1.
vpc_subnetwork_cidr_range      --> The IP address range of the VPC in CIDR notation. Ex: 10.0.0.0/16.
cluster_secondary_range_cidr   --> This secondary range will be used for pod IP addresses. Ex: 10.10.0.0/18
services_secondary_range_cidr  --> This secondary range will be used for service ClusterIPs. Ex: 10.20.0.0/20
```

```shell
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.13.0...
Terraform has been successfully initialized!
```


Then, provision your AKS cluster by running `terraform apply`. This will 
take approximately 10 minutes.

```shell
$ terraform apply

# Output truncated...

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = dos-terraform-edu-gke
region = us-central1
```

## Configure kubectl

Configuring the kubectl is already inside the code. 


The
[Kubernetes Cluster Name](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/gke.tf#L63)
and [Region](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/vpc.tf#L29)
 correspond to the resources spun up by Terraform.

## Deploy and access Kubernetes Dashboard

To deploy the Kubernetes dashboard, run the following command. This will schedule 
the resources necessary for the dashboard.

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```

Finally, to access the Kubernetes dashboard, run the following command:

```plaintext
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

 You should be
able to access the Kubernetes dashboard at [http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).

## Authenticate to Kubernetes Dashboard

To view the Kubernetes dashboard, you need to provide an authorization token. 
Authenticating using `kubeconfig` is **not** an option. You can read more about
it in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui).

Generate the token in another terminal (do not close the `kubectl proxy` process).

```plaintext
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')

Name:         service-controller-token-m8m7j
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: service-controller
              kubernetes.io/service-account.uid: bc99ddad-6be7-11ea-a3c7-42010a800017
              
Type:  kubernetes.io/service-account-token

Data
====
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9...
ca.crt:     1119 bytes
```

Select "Token" then copy and paste the entire token you receive into the 
[dashboard authentication screen](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) 
to sign in. You are now signed in to the dashboard for your Kubernetes cluster.

