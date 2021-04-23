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

When using a container or VM driver (all drivers except none), it is best to reuse the Docker daemon inside the minikube cluster. This way there is no need to build the image on the host machine and push it into a docker registry. Just build the image inside the same docker daemon as minikube, which speeds up local deployments.

To point the current terminal session to use the docker daemon inside minikube, run the command below. After running the command, any *docker* command run in this current terminal session will run against the docker inside the minikube cluster.

Notes:<br>
(1) Remember to turn off the imagePullPolicy:Always (use imagePullPolicy:IfNotPresent or imagePullPolicy:Never) in the yaml file; otherwise, Kubernetes will not use the locally build image, and it will pull from the network.<br>
(2) Evaluating the docker-env is only valid for the current terminal session. By closing the terminal session, the system reverts to using its docker daemon.<br>
(3) In container-based drivers such as Docker or Podman, the docker-env evaluation needs to be done each time the minikube cluster is restarted.

To display the command to run depending on the OS being used; execute the given command.
>`\>` minikube docker-env

*For example, for Linux.<br>
$> eval $(minikube docker-env)*

To push a Docker image directly to minikube from the host.
The image will be cached and automatically pulled into all future minikube clusters created on the machine.
>`\>` minikube cache add [alpine:latest]

If the image changes after it has been cached, do *cache reload*.
>`\>` minikube cache reload

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

kubectl
=======
To display the client and server versions.
>`\>` kubectl version

To display the client version only.
>`\>` kubectl version --client

CRUD Commands
-------------
Edit deployment.
>`\>` kubectl edit deployment [deployment-name]

Delete deployment.
>`\>` kubectl delete deployment [deployment-name]

Use configuration file for CRUD
-------------------------------
To create a deployment from a configuration file.
>`\>` kubectl apply -f [deployment-name]-deployment.yaml

To delete a deployment with a configuration file.
>`\>` kubectl delete -f [deployment-name]-deployment.yaml

Status of different K8S components
----------------------------------
**Nodes**<br>
>`\>` kubectl get nodes

**Pod**<br>
>`\>` kubectl get pods<br>
>`\>` kubectl get pods -n [namespace-name]

Get the given pod's YAML.
>`\>` kubectl get pod [pod-name] -o yaml

To display only the names.
>`\>` kubectl get pods -o name<br>
>`\>` kubectl get pods -o name --all-namespaces<br>
>`\>` kubectl get pods -o name -n [namespace-name]

**Services**<br>
>`\>` kubectl get services

**Replicaset**<br>
>`\>` kubectl get replicaset

**Deployment**<br>
To list deployments in the *default* namespace.
>`\>` kubectl get deployment

To list deployments in the given namespaces.
>`\>` kubectl get deployment --namespace [namespace-name]<br>
>`\>` kubectl get deployment -n [namespace-name]

To list deployments in all namespaces.
>`\>` kubectl get deployment --all-namespaces

**Events**<br>
To display all events created in the current K8S namespace. If an issue occurs while creating the Deployment, a set of errors or warnings will be displayed.
>`\>` kubectl get events

Debugging Pods
--------------
**To find the ENTRYPOINT and CMD of a container**<br>
If the container is crashing continuously (e.g., CrashLoopBackOff), then inspect the container while running in K8S. To do so, change the container ENTRYPOINT or K8S *command* under *containers*. In Linux, set *command* to *tail -f /dev/null* or *sleep infinity*.
>`\>` docker pull [image]<br>
>`\>` docker inspect [image-id]

**Logs**<br>
Log to console.
>`\>` kubectl logs [pod-name]<br>
>`\>` kubectl logs [pod-name] -n [namespace-name]

**Interactive Terminal**<br>
Get interactive terminal.
>`\>` kubectl exec -it [pod-name] -- [/bin/bash]/[/bin/sh]

**Metadata**<br>
Get metadata about pod.
>`\>` kubectl describe pod [pod-name]

Get metadata about deployment.
>`\>` kubectl describe deployment [deployment-name]

ConfigMap
---------
To display all configmaps available in the current K8S namespace.
>`\>` kubectl get configmaps

Secret
------
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
-------
For a Service of the LoadBalancer type to work, K8S uses an external load balancer.

To create a Service.
>`\>` kubectl apply -f [service-name].service.yaml

To display all services created in the current K8S namespace.
>`\>` kubectl get services

Service Accounts
----------------
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





