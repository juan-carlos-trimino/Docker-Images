Tools
=====
Minikube
--------
Setup a single-node K8S cluster on a local machine.<br>
https://kubernetes.io/docs/setup/minikube/

Note: Minikube will only run Linux based containers.<br>

To verify minikube is running.<br>
>`\>` minikube status

To display the current context.
>`\>` kubectl config current-context

To change the current context to minikube.
>`\>` kubectl config use-context minikube

To start the local cluster from a terminal with administrator access, but not logged in as root.
>`\>` minikube start

To stop the local minikube cluster.
>`\>` minikube stop

To open the dashboard in the system's default web browser.
>`\>` minikube dashboard

To display the dashboard URL.
>`\>` minikube dashboard --url

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br>
Instructions to install minikube in Windows.<br>
https://iteritory.com/install-minikube-in-windows-10-laptop-step-by-step-tutorial/
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br>

Docker Desktop
--------------
Setup a single-node K8S cluster on a local machine.<br>
https://docs.docker.com/desktop/

To display the current context.
>`\>` kubectl config current-context

To change the current context to docker-for-desktop.
>`\>` kubectl config use-context docker-for-desktop

Base64
------
To convert a binary file to a base64-encoded text file.<br>
https://www.browserling.com/tools/file-to-base64

Base64 Encode and Decode<br>
https://base64.guru/converter/decode/file
http://www.base64decode.org

PEM
---
To decode a PEM file.<br>
https://report-uri.com/home/pem_decoder

JWT
---
JWT decoder<br>
http://jwt.io

kubectl
=======
>`\>` kubectl version --client

Kubernetes Architecture Overview
================================
K8S uses the *client-server architecture*. A K8S cluster consists of one or more master nodes and one or more worker nodes.

Master Node (Control Plane)
---------------------------
The master node controls and manages the cluster and consists of four main components:<br>
*API Server* exposes the K8S API and provides the frontend to the cluster's shared state through which all other components interact.<br>
*Scheduler* schedules the apps by assigning a worker node to each deployable component of the app.<br>
*Controller Manager* performs cluster-level functions such as replicating components, keeping track of worker nodes, etc.<br>
*etcd* is a key:value distributed data store that persistently stores the cluster configuration.

Worker Node
-----------
K8S runs workloads (containers) on worker nodes; a worker node consists of three main components:<br>
*Kubelet* communicates with the API Server and manages containers running in a Pod on its node.<br>
*Kube-Proxy* load-balances network traffic between application components.<br>
*Container Runtime* runs the containers; e.g., Docker.

Deployment
==========
To create a deployment.
>`\>` kubectl apply -f [deployment-name]-deployment.yaml

To delete a deployment.
>`\>` kubectl delete -f [deployment-name]-deployment.yaml

To list deployments in the *default* namespace.
>`\>` kubectl get deployment

To list deployments in the given namespaces.
>`\>` kubectl get deployment --namespace [namespace-name]
>`\>` kubectl get deployment -n [namespace-name]

To list deployments in all namespaces.
>`\>` kubectl get deployment --all-namespaces

To display the metadata related to the deployment.
>`\>` kubectl describe deployment xxxxxxx

To display all events created in the current K8S namespace. If an issue occurs while creating the Deployment, a set of errors or warnings will be displayed.
>`\>` kubectl get events

To display logs. To run this command against a given Pod, get the name of the Pod.
>`\>` kubectl get pods
>`\>` kubectl logs [pod-name]

ConfigMap
=========
To display all configmaps available in the current K8S namespace.
>`\>` kubectl get configmaps

Secret
======
Because how K8S handles Secrets internally, always use **Secret** over **ConfigMap** to store sensitive data. K8S ensures that Secrets are only accessible to the Pods that need them, and Secrets are never written to disk; Secrets are kept in memory. K8S writes Secrets to disk only at the master node, where all Secrets are stored in etcd. etcd is the distributed key/value database use by K8S, and since K8S 1.7+, etcd stores Secrets only in an encrypted format.

To create a Secret.
>`\>` kubectl apply -f [secret-name].secrets.yaml

To display the structure of a Secret.
>`\>` kubectl get secret [secret-name] -o yaml

To display all secrets available in the current K8S namespace.
>`\>` kubectl get secrets

K8S provisions a Secret to each container in a Pod; this is called the *default token secret*.
To see the default token secret.
>`\>` kubectl get secrets

To display the structure of the default token secret in YAML format.<br>
The name/value pairs under the *data* element carry the confidential data in base64-encoded format. The default token secret has three name/value pairs:<br>
```
ca.crt - The root certificate of the K8S cluster.<br>
         (1) Use a tool to base64-decode to a file; the PEM-encoded root certificate of the K8S cluster.<br>
         (2) Use a tool to decode the PEM file.
token  - This is a **JSON Web Token** (**JWT**), which is base64-encoded.<br>
         Each container in a K8S Pod has access to this JWT from its filesystem in the directory /var/run/secrets/kuberenetes.io/serviceaccount. This JWT is bound to a K8S service account; e.g., to access the K8S API server from a container, use this JWT for authentication.
         (1) Use a tool to base64-decode the token.<br>
         (2) Use a tool to decode the JWT.
```
>`\>` kubectl get secret [default-token-secret-name] -o yaml

Service
=======
For a Service of the LoadBalancer type to work, K8S uses an external load balancer.

To create a Service.
>`\>` kubectl apply -f [service-name].service.yaml

To display all services created in the current K8S namespace.
>`\>` kubectl get services

Service Accounts
================
K8S uses two types of accounts for authentication and authorization: user accounts and service accounts. While K8S creates and manages service accounts, user accounts are not created or managed by K8S. A service account provides an identity to a Pod, and K8S uses the service account to authenticate a Pod to the API server.

K8S binds each Pod to a service account. Multiple Pods can be bound to the same service account, but multiple service accounts can't be bound to the same Pod. That is, when a K8S namespace is created, by default K8S creates a service account called *default*. This service account is assigned to all the Pods that are created in the namespace, unless a Pod is created under a specific service account.

By default, at the time a K8S cluster is created, K8S creates a service account for the default namespace.<br>
To display more information about the default service account.
>`\>` kubectl get serviceaccount default -o yaml

To display all service accounts available in the current K8S namespace.
>`\>` kubectl get serviceaccounts

At the time of creating the service account, K8S creates a token secret (JWT) and attaches it to the service account. All Pods bound to this service account can use the token secret to authenticate to the API server.
To create a service account.
>`\>` kubectl create serviceaccount [serviceaccount-name]

To display more information in YAML format about a given service account.
>`\>` kubectl get serviceaccount [serviceaccount-name] -o yaml





