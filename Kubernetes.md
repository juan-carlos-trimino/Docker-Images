***
# Tools
## Base64
Convert a binary file to a base64-encoded text file.<br>
https://www.browserling.com/tools/file-to-base64

Base64 Encode and Decode<br>
https://base64.guru/converter/decode/file
http://www.base64decode.org

<br>

## PEM
Decode a PEM file.<br>
https://report-uri.com/home/pem_decoder

<br>

## JWT
JWT decoder<br>
http://jwt.io

<br>

***
# Minikube
Setup a single-node K8S cluster on a local machine.<br>
https://kubernetes.io/docs/setup/minikube/

#### Notes
1. Minikube runs Kubernetes inside a Virtual Machine (VM) run through either VirtualBox or Hyper-V.
2. Minikube will only run Linux based containers.
3. Since Minikube doesn't support *LoadBalancer* services, services will never get an external IP.

**Start a K8S cluster (Windows).**<br>
Once the VM is running, go to *Control Panel -> Administrative Tools -> Hyper-V Manager -> Virtual Machines -> minikube* and double-click on **minikube** to connect to the newly created VM (**minikube**); use **docker** for username and **tcuser** for the password.
>`>` minikube start --vm-driver=hyperv

**Debug installation failure (Windows).**
>`>` minikube delete<br>
>`>` minikube start --vm-driver=hyperv --v=7 --alsologtostderr

**Get IP address of the cluster.**
>`>` minikube ip

**Start the local cluster from a terminal with administrator access, but not logged in as root.**
>`\>` minikube start

**Stop the local minikube cluster.**
>`\>` minikube stop

**Obtain the status of the cluster.**
>`\>` minikube status

**Get IP and port through which the service can be accessed.**
>`\>` minikube service [service-name]

**Open the dashboard in the system's default web browser.**
>`\>` minikube dashboard

**Display the dashboard URL.**
>`\>` minikube dashboard --url

**Display the current context. jct**
>`\>` kubectl config current-context

**Change the current context to minikube. jct**
>`\>` kubectl config use-context minikube

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

**Push a Docker image directly to minikube from the host.**
The image will be cached and automatically pulled into all future minikube clusters created on the machine.
>`\>` minikube cache add [alpine:latest]

**Context jct**
>`>` minikube config current-context

**If the image changes after it has been cached, do. jct**
>`\>` minikube cache reload

<br>

***
# Docker Desktop
Setup a single-node K8S cluster on a local machine.<br>
https://docs.docker.com/desktop/

**Display the current context.**
>`\>` kubectl config current-context

**Change the current context to docker-for-desktop.**
>`\>` kubectl config use-context docker-for-desktop

<br>

***
# Kubernetes (K8S)
## Architecture Overview
K8S uses the *client-server architecture*. A K8S cluster consists of one or more master nodes and one or more worker nodes.

<br>

### Master Node (Control Plane)
The master node controls and manages the cluster and consists of four main components:<br>
*API Server* exposes the K8S API and provides the frontend to the cluster's shared state through which all other components interact.<br>
*Scheduler* schedules the apps by assigning a worker node to each deployable component of the app.<br>
*Controller Manager* performs cluster-level functions such as replicating components, keeping track of worker nodes, etc.<br>
*etcd* is a key:value distributed data store that persistently stores the cluster configuration.

<br>

### Worker Node
K8S runs workloads (containers) on worker nodes; a worker node consists of three main components:<br>
*Kubelet* communicates with the API Server and manages containers running in a Pod on its node.<br>
*Kube-Proxy* load-balances network traffic between application components.<br>
*Container Runtime* runs the containers; e.g., Docker.

<br>

***
# kubectl
The double dash (--) in the command signals the end of command options for *kubectl*; all that follow the double dash is the command that should be executed inside the pod. If the command has no arguments that start with a dash, the double dash isn’t necessary.

## Version
**Display the *kubectl* (K8S client) version.**
>`\>` kubectl version --client<br>
>`\>` kubectl version --client --short<br>
>`\>` kubectl version --client -o="yaml"<br>
>`\>` kubectl version --client -o="json"

**Display the client (*kubectl*) and server versions.**
>`\>` kubectl version
>`\>` kubectl version --short  
>`\>` kubectl version -o="yaml"  
>`\>` kubectl version -o="json"

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

## Pods
#### Notes
1. Pods represent the basic deployable unit in K8S.
2. K8S assigns an IP address to a pod after the pod has been scheduled to a node and before it is started.
3. As soon as a pod is scheduled to a node, the Kubelet on that node will run its containers, and it will keep them running as long as the pod exists. If a container's main process crashes, the Kubelet will restart the container.
4. Since containers are not standalone K8S objects, they can't be listed individually.
5. It's common for a pod to contain only a single container, but when a pod contains multiple containers, all of them are run on a single worker node.
6. Because most of the container's filesystem comes from the container image, the filesystem of each container, by default, is fully isolated from other containers. But it is possible to have containers share file directories using *Volume*.
7. Container logs are automatically rotated daily and every time the log file reaches 10MB in size. Note that container logs can only be retrieved from running pods. Once a pod is deleted, its logs are also deleted.
8. When a pod is deleted, K8S terminates all of the containers that are part of the pod. K8S sends a SIGTERM signal to the main process of the container and waits a certain number of seconds, 30 is the default, for the main process to shut down gracefully. If it doesn't shut down in the given time, K8S sends a SIGKILL to the OS, and the OS kills it. To ensure processes are always shut down gracefully, they need to handle the SIGTERM signal properly.
9. To see the reason the previous container terminated, check the Exit Code. The exit code is the sum of two numbers: 128 + x, where x is the signal number sent to the process that caused it to terminate. For example, an exit code of 137 equals 128 + 9 (SIGKILL); likewise, an exit code of 143 equals 128 + 15 (SIGTERM).

### Listing
**Display the pods in the given namespace.**
>`\>` kubectl get pods -n [namespace-name]

**Display pods using a label selector.**
>`\> kubectl get pod -l [label-name]

**Display only the names.**
>`\>` kubectl get pods -o name --all-namespaces<br>
>`\>` kubectl get pods -o name -n [namespace-name]

**Retrieve the given pod's YAML.**
>`\>` kubectl get pod [pod-name] -n [namespace-name] -o yaml
>`\>` kubectl get pod [pod-name] -n [namespace-name] -o json

**Display more details of the given pod.**<br>
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
**Delete a pod by name. jct**
>`\>` kubectl delete pod [pod-name]<br>
>`\>` kubectl delete pod [pod-name1] [pod-name2]

**Delete all pods by deleting the namespace.**<br>
The pods will be deleted along with the namespace.
>`\>` kubectl delete ns [namespace-name]

**Delete all pods, but not the namespace.**<br>
If the pods were created by the ReplicationController, then when the pods are deleted, the ReplicationController will create replacement pods. To delete the pods, the ReplicationController must be deleted as well.
>`\>` kubectl delete pod --all -n [namespace-name]

### Interactive Terminal
**Execute commands in a running container.**
>`>` kubectl exec [pod-name] -- curl -s http://[IP-address-of-pod]  jct

**List environment variables.**
>`>` kubectl exec [pod-name] env

**Run a shell inside an existing container.**<br>
*The shell must be available in the image.*
>`\>` kubectl exec -it [pod-name] -- [shell]



### Labels
#### Notes
1. Labels are a Kubernetes feature for organizing **all** Kubernetes resources. A resource may have more than one label as long as the keys of the labels are unique within the resource.

**Add labels to pods managed by a ReplicationController.**
>`\>` kubectl label pod [pod-name] [label-name]=[label-value]

**Change the labels of a managed pod.**
>`\>` kubectl label pod [pod-name] [label-name]=[label-value] --overwrite

**List specific labels in their own columns.**
>`\>` kubectl get pods -L [label-name]

**List labels.**
>`\>` kubectl get pods --show-labels

**List pods using label selectors.**<br>
Display all pods with [label-name]=[label-value]
>`\>` kubectl get pod -l [label-name]=[label-value]

**Display all pods that include the [label-name] label.**
>`\>` kubectl get pod -l [label-name]

**Display all pods that do not include the [label-name] label.**
>`\>` kubectl get pod -l '![label-name]'

**Display all pods where [label-name]!=[label-value].**
>`\>` kubectl get pod -l [label-name]!=[label-value]

**Display all pods where [label-name] is either [label-value1] or [label-value2].**
>`\>` kubectl get pod -l [label-name] in ([label-value1], [label-value2])

**Display all pods where [label-name] is not either [label-value1] or [label-value2].**
>`\>` kubectl get pod -l [label-name] notin ([label-value1], [label-value2])

### Logs
**Display the log of a pod running one container.**<br>
Container logs are automatically rotated daily and every time the log file reaches 10MB in size.
>`\>` kubectl logs [pod-name] -n [namespace-name]

**Display the log of a pod running more than one container.**
>`\>` kubectl logs [pod-name] -c [container-name] -n [namespace-name]

**Retrieve the log of a crashed container.**
>`\>` kubectl logs [pod-name] --previous -n [namespace-name]

<br>

## Deployment
### Listing
**List deployments in the given namespace.**
>`\>` kubectl get deployment -n [namespace-name]

**List deployments in all namespaces.**
>`\>` kubectl get deployment --all-namespaces

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



***
***
***
The command-line option --record records the command in the revision history.
>`>` kubectl create -f [file-name].yaml --record

### IP addresses and ports
>`>` kubectl describe pod [pod-name] | Select-String -Pattern IP:  
>`>` kubectl describe pod [pod-name] | Select-String -Pattern Port:






### Listing, explaining, describing
**List deployment**
>`>` kubectl get deployment [deployment-namexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]  
>`>` kubectl get deploymentxxxxxxxxxxxxxxxxxxxxxxxxxxxxx [pod-namexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]

**Detail explanation of an object and its attributes**
>`>` kubectl explain xxxxxxxxxxxxxxxxxxxxxxxxxxxxxpods  
>`>` kubectl explain xxxxxxxxxxxxxxxxxxxxxxxxpod.spec

**Describe a pod**  
>`>` kubectl describe xxxxxxxxxxxxxxxxxxxxxxxxxxxxpod [pod-name]  
>`>` kubectl describe xxxxxxxxxxxxxxxxxxxxxxxxxxxxxpo [pod-name]

### Status
**Check a Deployment's status**
>`>` kubectl rollout status deployment [deployment-name]






# Service
## Notes
1. A service is a resource that creates a single point of entry to a group of pods providing the same service. The service has an IP address and port, and either will change while the service exists. Clients can then open connections to the IP address and port, and the connections are routed to one of the pods backing the service.
2. Services deal with TCP and UPD packets.
3. A service forwards each connection to a randomly selected backing pod. To redirect all requests made by the same client IP to the same pod, set the service's *sessionAffinity* property to ClientIP (the default is None). The session affinities supported by Kubernetes are: **None** and **ClientIP**.
4. When a service exposes multiple ports, each port must be given a name. All of the service's ports will be exposed through the service cluster IP.
5. The service *fully qualified domain name (FQDN)*  
   svc-name.default.svc.cluster.local  
   svc-name = service name  
   default = namespace the service is defined in  
   svc.cluster.local = a configurable cluster domain suffix used in all cluster local service names  

### Creation
**Create a service**
>`>` kubectl create -f filename.yaml

### Deletion
**Delete a service by name**
>`>` kubectl delete svc [svc-name]

### Endpoints
The service's pod selector is used to build a list of IPs and ports, which is stored in the Endpoints resource. When a client connects to a service, the service proxy selects from the Endpoints resource one pair of IP and port and redirects the incoming connection to the server listening at that location.  
**Display Endpoints information**
>`>` kubectl get endpoints [svc-name]

### Listing
**List services**  
Because this is the cluster IP, it is only accessible from inside the cluster. The primary purpose of services is to expose groups of pods to other pods in the cluster.
>`>` kubectl get service  
>`>` kubectl get svc

**List detail information**
>`>` kubectl describe svc [svc-name]



### Listing, explaining, describing

**List all running pods across all namespaces**
>`>` kubectl get po --all-namespaces

# Namespaces
## Notes
1. Kubernetes groups resources into namespaces; resource names only need to be unique within a namespace.
2. When performing an action (listing, modifying, etc.) on a namespace, *kubectl* performs the action in the default namespace configured in the current *kubectl* context. To perform the action on another namespace, pass the --namespace (or -n) flag to *kubectl*.

### Creation
**With a YAML manifest**
>`>` kubectl create -f [file-name].yaml

**With kubectl**
>`>` kubectl create namespace [namespace-name]

### Deletion
**Delete the ReplicationController, pods, and services by deleting all resources in the current namespace**  
Warning: This command does not delete all resources; some resources are **not** deleted.
>`>` kubectl delete all --all

### Listing
>`>` kubectl get ns  
>`>` kubectl get namespace  
>`>` kubectl get namespaces

# Services
**List services**
>`>` kubectl get services  
>`>` kubectl get svc

# ReplicaSet
## Notes
1. A ReplicaSet constantly monitors the list of running pods and ensures the actual number of pods with matching label selector always matches the desired number.

### Deleting
**Delete ReplicaSet**
>`>` kubectl delete rs [rs-name]

**Delete all ReplicaSet**
>`>` kubectl delete rs -all

### Listing
**List replica sets**
>`>` kubectl get replicaset  
>`>` kubectl get rs

**List details**
>`>` kubectl describe rs

# ReplicationController (Deprecated instead use ReplicaSet)
## Notes
1. A ReplicationController constantly monitors the list of running pods and ensures the actual number of pods with matching label selector always matches the desired number.

### Deleting
**Delete ReplicationController and its pods**
>`>` kubectl delete rc [rc-name]

**Delete ReplicationContorller *but* not its pods**  
Because a ReplicationController only manages the pods it creates, it is possible to delete only the ReplicationController and leave the pods running; the pods are no longer managed.
>`>` kubectl delete rc [rc-name] --cascade=false

### Listing
**List replication controllers**
>`>` kubectl get replicationcontrollers  
>`>` kubectl get rc

**List details**
>`>` kubectl describe rc [rc-name]

### Editing
**Edit the ReplicationController's YAML definition file**
Changing a ReplicationController's pod template only affects pods created after the change; it has no effect on existing pods.
>`>` kubectl edit rc [rc-name]

# DaemonSet
## Notes
1. DaemonSet runs only a single pod replica on each node.
2. Because DaemonSet bypasses the Scheduler, it can deploy pods to nodes that have been made un-schedulable, which prevents pods from being deployed to them.

# Job

# CronJob

# Dashboard
### Accessing
**From Google Kubernetes Engine (GKE)**
>$ kubectl cluster-info | grep dashboard  
>`PS>` kubectl cluster-info | Select-String -Pattern dashboard






The app itself needs to support being scaled horizontally. Kubernetes doesn't make an app scalable; it only supports scaling the app up or down.

A base image is the root Operating System (OS) filesystem. The base image uses the OS kernel from the host. Because the OS could bring with it vulnerabilities, it is best practice to keep the base image as minimal as possible.


kubectl run rmq --image=jctrimino/rabbitmq-3.8.1-erlang-22.1:windowsserver-1903 --port=15672 --port=5672 --generator=run-pod/v1


