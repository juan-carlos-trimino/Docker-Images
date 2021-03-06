***
# Theorems
## CAP Theorem
(https://en.wikipedia.org/wiki/CAP_theorem)<br>
The theorem, proven by Eric Brewer, states that *a distributed system can only have two of the following three properties*: **Consistency, Availability, and Partition-Tolerant (CAP)**.
Since a distributed system will always suffer from occasional network partition, it can only be *either* **consistent** *or* **available**. Distributed systems are generally configured to favor **availability** over **consistency**; favoring **availability** over **consistency** means that when a client makes a request for information, it will always get an answer, but that answer may be stale.<br>

The recommended minimum size of a *quorum (majority) distributed system cluster* is three (3) to provide fault tolerance in the case of failure.<br>
|Servers|No. Required for Majority|Failure Tolerance|
|:---:|:---:|:---:|
|1|1|0|
|2|2|0|
|3|2|1|
|4|3|1|
|5|3|2|
|6|4|2|
|7|4|3|
<br>

Please note the following:
1. If there is only one server, writes (data) will be lost in the event of failure.
2. If there are two servers and one fails, the remaining server will be unable to reach a quorum; writes will be lost until the second server returns.
3. If more servers are added, fault tolerance is improved; however, write performance is reduced since data need to be replicated to more servers.
4. If the size of the cluster grows beyond seven (7), the probability of losing enough servers to not have a quorum is low enough that is not worth the performance trade-off.
5. If a distributed system has more than seven (7) servers, five (5) or seven (7) servers can be used to form the cluster, and the remaining servers run clients that can query the system but do not take part in the quorum.
6. Even numbers are generally best avoided since they increase the cluster size (decreasing performance) but do not improve failure tolerance.

<br>

***
# Tools
## Base64
Convert a binary file to a base64-encoded text file.<br>
https://www.browserling.com/tools/file-to-base64

Base64 Encode and Decode<br>
https://base64.guru/converter/decode/file
http://www.base64decode.org

<br>

## JSON
JSON Formatter and Validator<br>
https://jsonformatter.curiousconcept.com

<br>

## JSON Web Token (JWT) [RFC 7519]
Decode, verify, and generate JWT.<br>
http://jwt.io

<br>

## JSON Web Key (JWK) [RFC 7517]
A JWK is a JSON representation of a cryptographic key.<br>

JWK to PEM Converter.<br>
https://8gwifi.org/jwkconvertfunctions.jsp

<br>

## Privacy Enhanced Mail (PEM)
Decode a PEM file.<br>
https://report-uri.com/home/pem_decoder

<br>

***
# Minikube
Setup a single-node K8s cluster on a local machine.<br>
https://kubernetes.io/docs/setup/minikube/

#### Notes
1. Minikube runs Kubernetes inside a Virtual Machine (VM) run through either VirtualBox or Hyper-V.
2. Minikube will only run Linux based containers.
3. Since Minikube doesn't support *LoadBalancer* services, services will never get an external IP.

### Cluster
**Start a K8s cluster (Windows).**<br>
Once the VM is running, go to *Control Panel -> Administrative Tools -> Hyper-V Manager -> Virtual Machines -> minikube* and double-click on **minikube** to connect to the newly created VM (**minikube**); use **docker** for username and **tcuser** for the password.
>`\>` minikube start --vm-driver=hyperv

**Debug installation failure (Windows).**
>`\>` minikube delete<br>
>`\>` minikube start --vm-driver=hyperv --v=7 --alsologtostderr

### Manage minikube
**Start the local cluster from a terminal with administrator access, but not logged in as root.**
>`\>` minikube start

**Stop the local minikube cluster.**
>`\>` minikube stop

**Obtain the status of the cluster.**
>`\>` minikube status

### Context
When using a container or VM driver (all drivers except none), it is best to reuse the Docker daemon inside the minikube cluster. This way there is no need to build the image on the host machine and push it into a docker registry. Just build the image inside the same docker daemon as minikube, which speeds up local deployments.

To point the current terminal session to use the docker daemon inside minikube, run the command below. After running the command, any *docker* command run in this current terminal session will run against the docker inside the minikube cluster.

#### Notes
1. Remember to turn off the imagePullPolicy:Always (use imagePullPolicy:IfNotPresent or imagePullPolicy:Never) in the yaml file; otherwise, Kubernetes will not use the locally build image, and it will pull from the network.
2. Evaluating the docker-env is only valid for the current terminal session. By closing the terminal session, the system reverts to using its docker daemon.
3. In container-based drivers such as Docker or Podman, the docker-env evaluation needs to be done each time the minikube cluster is restarted.

**Display the command to run depending on the OS/shell being used; execute the given command.**
>`\>` minikube docker-env

*For example, for Linux.<br>
$> eval $(minikube docker-env)*

**Display the current context.**
>`\>` kubectl config current-context

**Change the current context to minikube.**
>`\>` kubectl config use-context minikube

### Listing
**List IP address of the cluster.**
>`\>` minikube ip

**List IP and port through which the service can be accessed.**
>`\>` minikube service [service-name] -n [namespace-name]

### Add-ons
**List all add-ons.**
>`\>` minikube addons list

**Enable an add-on.**
>`\>` minikube addons enable [add-on-name]

**Disable an add-on.**
>`\>` minikube addons disable [add-on-name]

### Dashboard
**Open the dashboard in the system's default web browser.**
>`\>` minikube dashboard

**Display the dashboard URL.**
>`\>` minikube dashboard --url

### Caching
**Push a Docker image directly to minikube from the host.**
The image will be cached and automatically pulled into all future minikube clusters created on the machine.
>`\>` minikube cache add [alpine:latest]

**If the image changes after it has been cached, reload.**
>`\>` minikube cache reload

<br>

***
# Docker Desktop
Setup a single-node K8s cluster on a local machine.<br>
https://docs.docker.com/desktop/

**Display the current context.**
>`\>` kubectl config current-context

**Change the current context to docker-for-desktop.**
>`\>` kubectl config use-context docker-for-desktop

<br>

***
# Kubernetes (K8s)
## Architecture Overview
K8s uses the *client-server architecture*. A K8s cluster consists of one or more master nodes and one or more worker nodes.

<br>

### Master Node (Control Plane)
The master node controls and manages the cluster and consists of four main components:
1. *API Server* exposes the K8s API and provides the frontend to the cluster's shared state through which all other components interact.
   1. It is the central component used by all other components and clients (e.g., kubectl).
   2. It provides a CRUD (Create, Read, Update, Delete) interface for querying and modifying the cluster state over a RESTful API.
   3. It uses etcd to store the state.
2. *Scheduler* schedules the apps by assigning a worker node to each deployable component of the app.
   1. It monitors the API server's watch mechanism and assigns a cluster node to the new pod.
   2. It updates the pod definition through the API server. The API server notifies the Kubelet (using the watch mechanism) that a pod has been scheduled. When the Kubelet on the target node receives the notification, it creates and runs the pod's containers.
   3. By default, pods belonging to the same Service or ReplicaSet are distributed across multiple nodes, but this is not always guaranteed.
   4. A cluster may have multiple Schedulers running, and a pod may specify the Scheduler that should schedule it by setting the *schedulerName* property in the pod spec. Pods without the *schedulerName* property set or with the *schedulerName* property set to *default-scheduler* are scheduled using the default Scheduler; all other pods are ignored by the default Scheduler.
3. *Controller Manager* performs cluster-level functions such as replicating components, keeping track of worker nodes, etc.
   1. x
4. *etcd* is a key:value distributed data store that persistently stores the cluster configuration.
   1. x

<br>

### Worker Node
K8s runs workloads (containers) on worker nodes; a worker node consists of three main components:
1. *Kubelet* communicates with the API Server and manages containers running in a Pod on its node.
2. *K8s Service Proxy (Kube-Proxy)* load-balances network traffic between application components.
3. *Container Runtime* runs the containers; e.g., Docker.

<br>

***
# kubectl
#### Notes
1. The double dash (--) in the command signals the end of command options for *kubectl*; all that follow the double dash is the command that should be executed inside the pod. If the command has no arguments that start with a dash, the double dash isn’t necessary.
2. To use a different text editor with *kubectl*, set the KUBE_EDITOR environment variable.<br>
   export KUBE_CONTROL="path_to_new_editor"<br>
   If this environment variable is not set, *kubectl* uses the default editor.

## Version
**Display the *kubectl* (K8s client) version.**
>`\>` kubectl version --client<br>
>`\>` kubectl version --client --short<br>
>`\>` kubectl version --client -o="yaml"<br>
>`\>` kubectl version --client -o="json"

**Display the client (*kubectl*) and server versions.**
>`\>` kubectl version<br>
>`\>` kubectl version --short<br>
>`\>` kubectl version -o="yaml"<br>
>`\>` kubectl version -o="json"

<br>

## Control Plane Components
**Status of Components**
>`\>` kubectl get componentstatuses

<br>

## Cluster information
>`>` kubectl cluster-info

<br>

## Nodes
**Get all nodes in the cluster.**
>`>` kubectl get nodes

**Get additional details for given node.**
>`>` kubectl describe node [node-name]

**Get additional details for all nodes.**
>`>` kubectl describe node

<br>

## Objects
### Status
**List all possible object types.**
>`\>` kubectl get

<br>

## Deployment
### Listing
**List deployments in the given namespace.**
>`\>` kubectl get deployment -n [namespace-name]

**List deployments in all namespaces.**
>`\>` kubectl get deployment --all-namespaces

**List all events created in the given namespace.**<br>
If an issue occurs while creating the Deployment, a set of errors or warnings will be displayed.
>`\>` kubectl get events -n [namespace-name]

### Creation
**Create a deployment from a configuration file.**
>`\>` kubectl apply -f [deployment-name]-deployment.yaml

### Deletion
**Delete deployment.**
>`\>` kubectl delete deployment [deployment-name]

**Delete a deployment with a configuration file.**
>`\>` kubectl delete -f [deployment-name]-deployment.yaml

### Editing
**Edit deployment.**
>`\>` kubectl edit deployment [deployment-name]

### Status
**Check a Deployment's status.**
>`\>` kubectl rollout status deployment [deployment-name]

<br>

## Pods
#### Notes
1. Pods represent the basic deployable unit in K8s.
2. K8s assigns an IP address to a pod after the pod has been scheduled to a node and before it is started.
3. As soon as a pod is scheduled to a node, the Kubelet on that node will run its containers, and it will keep them running as long as the pod exists. If a container's main process crashes, the Kubelet will restart the container.
4. Since containers are not standalone K8s objects, they can't be listed individually.
5. It's common for a pod to contain only a single container, but when a pod contains multiple containers, all of them are run on a single worker node.
6. Because most of the container's filesystem comes from the container image, the filesystem of each container, by default, is fully isolated from other containers. But it is possible to have containers share file directories using *Volume*.
7. Container logs are automatically rotated daily and every time the log file reaches 10MB in size. Note that container logs can only be retrieved from running pods. Once a pod is deleted, its logs are also deleted.
8. When a pod is deleted, K8s terminates all of the containers that are part of the pod. K8s sends a SIGTERM signal to the main process of the container and waits a certain number of seconds, 30 is the default, for the main process to shut down gracefully. If it doesn't shut down in the given time, K8s sends a SIGKILL to the Operating System (OS), and the OS kills it. To ensure processes are always shut down gracefully, they need to handle the SIGTERM signal properly.
9. To see the reason the previous container terminated, check the Exit Code. The exit code is the sum of two numbers: 128 + x, where x is the signal number sent to the process that caused it to terminate. For example, an exit code of 137 equals 128 + 9 (SIGKILL); likewise, an exit code of 143 equals 128 + 15 (SIGTERM).

### Listing
**List the pods in the given namespace.**
>`\>` kubectl get pods -n [namespace-name]

**List all running pods across all namespaces**
>`\>` kubectl get pods --all-namespaces

**List pods using a label selector.**
>`\> kubectl get pod -l [label-name]

**List only the names.**
>`\>` kubectl get pods -o name --all-namespaces<br>
>`\>` kubectl get pods -o name -n [namespace-name]

**Retrieve the given pod's YAML.**
>`\>` kubectl get pod [pod-name] -n [namespace-name] -o yaml
>`\>` kubectl get pod [pod-name] -n [namespace-name] -o json

**List more details of the given pod.**<br>
Find why the container had to be restarted.<br>
&nbsp;&nbsp;Last State:<br>
&nbsp;&nbsp;&nbsp;&nbsp;Exit Code:
>`\>` kubectl describe pod [pod-name] -n [namespace-name]

**Detail explanation of an object and its attributes.**
>`\>` kubectl explain pods<br>
>`\>` kubectl explain pod.spec

### Creation
**Create a pod.**
>`>` kubectl create -f filename.yaml

### Deletion
**Delete all pods by deleting the namespace.**<br>
The pods will be deleted along with the namespace.
>`\>` kubectl delete ns [namespace-name]

**Delete all pods, but not the namespace.**<br>
If the pods were created by the ReplicationController, then when the pods are deleted, the ReplicationController will create replacement pods. To delete the pods, the ReplicationController must be deleted as well.
>`\>` kubectl delete pod --all -n [namespace-name]

**Delete a pod by name.**
If the pods were created by the ReplicationController, then when the pods are deleted, the ReplicationController will create replacement pods. To delete the pods, the ReplicationController must be deleted as well.
>`\>` kubectl delete pod [pod-name] -n [namespace-name]<br>
>`\>` kubectl delete pod [pod-name1] [pod-name2] -n [namespace-name]

### Interactive Terminal for Debugging
**Execute commands in a running container.**
>`\>` kubectl exec [pod-name] -- curl -s http://[IP-address-of-pod]  jct

**List environment variables.**
>`\>` kubectl exec [pod-name] -n [namespace-name] -- [env | ls -al | COMMAND]

**Find the ENTRYPOINT and CMD of a container**<br>
If the container is crashing continuously (e.g., CrashLoopBackOff), then inspect the container while running in K8s. To do so, change the container ENTRYPOINT or K8s *command* under *containers*. In Linux, set *command* to *tail -f /dev/null* or *sleep infinity*.
>`\>` docker pull [image]<br>
>`\>` docker inspect [image-id]

**Run a shell inside an existing container.**<br>
*The shell must be available in the image.*
>`\>` kubectl exec -it [pod-name] -n [namespace-name] -- [shell]

### Find IP addresses and ports
>`PS>` kubectl describe pod [pod-name] -n [namespace-name] | Select-String -Pattern IP:<br>
>`PS>` kubectl describe pod [pod-name] -n [namespace-name] | Select-String -Pattern Port:

### Labels
#### Notes
1. Labels are a Kubernetes feature for organizing **all** Kubernetes resources. A resource may have more than one label as long as the keys of the labels are unique within the resource.

**Add labels to pods managed by a ReplicationController.**
>`\>` kubectl label pod [pod-name] [label-name]=[label-value]

**Change the labels of a managed pod.**
>`\>` kubectl label pod [pod-name] [label-name]=[label-value] --overwrite

**List specific labels in their own columns.**
>`\>` kubectl get pods -L [label-name] -n [namespace-name]

**List labels.**
>`\>` kubectl get pods --show-labels -n [namespace-name]

**List pods using label selectors.**<br>
Display all pods with [label-name]=[label-value]
>`\>` kubectl get pod -l [label-name]=[label-value] -n [namespace-name]

**Display all pods that include the [label-name] label.**
>`\>` kubectl get pod -l [label-name] -n [namespace-name]

**Display all pods that do not include the [label-name] label.**
>`\>` kubectl get pod -l '![label-name]' -n [namespace-name]

**Display all pods where [label-name]!=[label-value].**
>`\>` kubectl get pod -l [label-name]!=[label-value] -n [namespace-name]

**Display all pods where [label-name] is either [label-value1] or [label-value2].**
>`\>` kubectl get pod -l [label-name] in ([label-value1], [label-value2]) -n [namespace-name]

**Display all pods where [label-name] is not either [label-value1] or [label-value2].**
>`\>` kubectl get pod -l [label-name] notin ([label-value1], [label-value2]) -n [namespace-name]

### Logs
**Display the log of a pod running one container.**<br>
Container logs are automatically rotated daily and every time the log file reaches 10MB in size.
>`\>` kubectl logs [pod-name] -n [namespace-name]

**Display the log of a pod running more than one container.**
>`\>` kubectl logs [pod-name] -c [container-name] -n [namespace-name]

**Retrieve the log of a crashed container.**
>`\>` kubectl logs [pod-name] --previous -n [namespace-name]

<br>

## Service
#### Notes
1. A service is a resource that creates a single point of entry to a group of pods providing the same service. When a service is created, it gets a static IP, which never changes during the lifetime of the service. Hence, clients should connect to the service through its static IP address and not to pods directly (pods are ephemeral). The service ensures one of the pods receives the connection, regardless of the pod's current IP address.
2. Services deal with TCP and UPD packets.
3. For a Service of the LoadBalancer type to work, K8s uses an external load balancer.
4. A service forwards each connection to a randomly selected backing pod. To redirect all requests made by the same client IP to the same pod, set the service's *sessionAffinity* property to ClientIP (the default is None). The session affinities supported by Kubernetes are: **None** and **ClientIP**.
5. When a service exposes multiple ports, each port must be given a name. All of the service's ports will be exposed through the service cluster IP.
6. The service *fully qualified domain name (FQDN)*<br>
   svc-name.default.svc.cluster.local<br>
   svc-name = service name<br>
   default = namespace the service is defined in<br>
   svc.cluster.local = a configurable cluster domain suffix used in all cluster local service names.

### Listing
**List services**<br>
If this is a cluster IP, it is only accessible from inside the cluster. The primary purpose of services is to expose groups of pods to other pods in the cluster.
>`\>` kubectl get [services | svc]

**List detail information**
>`\>` kubectl describe svc [svc-name]

### Creation
**Create a service**
>`\>` kubectl create -f filename.yaml<br>
>`\>` kubectl apply -f [service-name].service.yaml

### Deletion
**Delete a service by name**
>`\>` kubectl delete svc [svc-name]

### Endpoints
#### Notes
1. The service's pod selector is used to build a list of IPs and ports, which is stored in the Endpoints resource. When a client connects to a service, the service proxy selects from the Endpoints resource one pair of IP and port and redirects the incoming connection to the server listening at that location.

**List Endpoints information**
>`\>` kubectl get endpoints [svc-name]

### Exposing Services Externally
#### Notes
1. There are three ways to expose a K8s Service outside a K8s cluster: **NodePort Service**, **LoadBalancer Service**, and **Ingress**.
2. Ingress
   - Ingress (noun) - The act of going in or entering; the right to enter; a means or place of entering; entryway.
   - Ingress is a K8s resource that routes traffic from outside the cluster to a K8s Service over HTTP or HTTPS.
   - An Ingress controller must be running in the cluster for Ingress to work; some K8s environments provide their unique implementations of the controller whereas others do not.
   - Ingress can expose one or more K8s Services through a single IP address; the host and path in the HTTP/HTTPS request determine which service receives the request.
   - When a client opens a TLS connection to an Ingress controller, the controller terminates the TLS connection. The communication between the client and the controller is encrypted, but the communication between the controller and the pod is not.
   - If the Ingress controller needs to support TLS, it will require a public certificate and a private key. The private key must be stored in a K8s Secret resource.

#### Ingress
**Enable/disable the Ingress add-on in Minikube**
>`\>` minikube addons list<br>
>`\>` minikube addons enable ingress<br>
>`\>` minikube addons disable ingress

**List the pod running the Ingress controller**<br>
Since the namespace that the pod is in is not known, use --all-namespaces.
>`\>` kubectl get pods --all-namespaces

**Access a Service through Ingress**<br>
To access a Service through the domain name (see *host:* in the Ingress resource definition yaml file; e.g., http://trimino.com), ensure the domain name resolves to the IP of the Ingress controller.<br>
To obtain the IP address of the Ingress.<br>
>`\>` kubectl get ingresses<br>

Once the IP is obtained, configure the DNS server to resolve trimino.com to that IP, or add the following line to /etc/hosts in Linux (in Windows C:\Windows\system32\drivers\etc\hosts)<br>

192.168.45.100&nbsp;&nbsp;&nbsp;&nbsp;trimino.com

<br>

## Namespaces
#### Notes
1. Kubernetes groups resources into namespaces; resource names only need to be unique within a namespace.
2. When performing an action (listing, modifying, etc.) on a namespace, *kubectl* performs the action in the default namespace configured in the current *kubectl* context. To perform the action on another namespace, pass the --namespace (or -n) flag to *kubectl*.

### Listing
>`\>` kubectl get [ns | namespace | namespaces]

### Creation
**With a YAML manifest.**
>`\>` kubectl create -f [file-name].yaml

**With kubectl**
>`\>` kubectl create namespace [namespace-name]

### Deletion
**Delete almost all resources in the given namespace.**<br>
Warning: This command does not delete all resources; some resources are **not** deleted.
>`\>` kubectl delete all --all -n [namespace-name]

<br>

## ReplicaSet
#### Notes
1. A ReplicaSet constantly monitors the list of running pods and ensures the actual number of pods with matching label selector always matches the desired number.

### Listing.
**List replica sets.**
>`\>` kubectl get [rs | replicaset] -n [namespace-name]

### Deleting
**Delete ReplicaSet.**
Deleting a ReplicaSet will delete all its pods.
>`\>` kubectl delete rs [rs-name] -n [namespace-name]

**Delete all ReplicaSet.**
>`\>` kubectl delete rs --all -n [namespace-name]

<br>

## ReplicationController (Deprecated instead use ReplicaSet)

<br>

## Service Accounts
#### Notes
1. K8s uses two types of accounts for *authentication* and *authorization*: *user accounts* and *service accounts*. While K8s creates and manages service accounts, user accounts are not created or managed by K8s.
2. A service account provides an identity to a pod, and K8s uses the service account to authenticate a pod to the API server.
3. K8s binds each pod to a service account; multiple pods can be bound to the same service account, but a pod can be bound to exactly one service account. That is, when a K8s namespace is created, by default K8s creates a service account called *default*. This service account is assigned to all the pods that are created in the namespace, unless a pod is created under a specific service account.
4. A pod can only be bound to a service account from the same namespace.
5. A namespace contains its own default service account, but additional service accounts can be created, if necessary.
6. By default, at the time a K8s cluster is created, K8s creates a service account for the default namespace.
7. At the time of creating a service account, K8s creates a token secret and attaches it to the service account. All pods bound to this service account can use the token secret to authenticate to the API server. (The authentication tokens used in service accounts are JSON Web Tokens (JWT).)

### Listing
**List all service accounts available in the current K8s namespace.**
>`\>` kubectl get serviceaccounts<br>
>`\>` kubectl get sa<br>

**List more information about the default service account.**
>`\>` kubectl get serviceaccount default -o yaml

**List more information in YAML format about a given service account.**
>`\>` kubectl get sa [serviceaccount-name] -o yaml

**Inspecting a service account.**
>`\>` kubectl describe sa [serviceaccount-name]

### Creation
**Create a service account.**
>`\>` kubectl create serviceaccount [serviceaccount-name]

<br>

## ConfigMap
#### Notes
1. A key must be a valid DNS subdomain; i.e., it may only contain alphanumeric characters, dashes, underscores, and dots. It may optionally include a leading dot.
2. The contents of a ConfigMap's entries are shown in clear text.

### Listing
List all configmaps available in the current K8s namespace.
>`\>` kubectl get configmaps

<br>

## Secret
#### Notes
1. The maximum size of a Secret is limited to 1MB.
2. The contents of a Secret's entries are shown as Base64-encoded strings.
3. A Secret's entries can contain plain-text or binary value.
3. Because how K8s handles Secrets internally, always use **Secret** over **ConfigMap** to store sensitive data. K8s ensures that Secrets are only accessible to the Pods that need them, and Secrets are never written to disk; Secrets are kept in memory. K8s writes Secrets to disk only at the master node, where all Secrets are stored in etcd. etcd is the distributed key/value database use by K8s, and since K8s 1.7+, etcd stores Secrets only in an encrypted format.
4. K8s provisions a Secret to each container in a Pod; this is called the *default token secret*.
5. Each container in a K8s Pod has access to this JWT from its filesystem in the directory /var/run/secrets/kuberenetes.io/serviceaccount. This JWT is bound to a K8s service account; e.g., to access the K8s API server from a container, use this JWT for authentication.

### Listing
**List the structure of a Secret.**
>`\>` kubectl get secret [secret-name] -o yaml

**List the default token secret.**
>`\>` kubectl get secrets

**List the structure of the default token secret in YAML format.**<br>
The name/value pairs under the *data* element carry the confidential data in base64-encoded format. The default token secret has three name/value pairs:<br>
ca.crt - The root certificate of the K8s cluster.
#### Notes
1. Use a tool to base64-decode to a file; the PEM-encoded root certificate of the K8s cluster.
2. Use a tool to decode the PEM file.

token  - This is a **JSON Web Token** (**JWT**), which is base64-encoded.
#### Notes
1. Use a tool to base64-decode the token.
2. Use a tool to decode the JWT.
>`\>` kubectl get secret [default-token-secret-name] -o yaml

### Creation
**Create a Secret.**
>`\>` kubectl apply -f [secret-name].secrets.yaml

<br>

## DaemonSet
#### Notes
1. DaemonSet runs only a single pod replica on each node.
2. Because DaemonSet bypasses the Scheduler, it can deploy pods to nodes that have been made un-schedulable, which prevents pods from being deployed to them.
