# Minikube runs Kubernetes inside a Virtual Machine (VM) run through either VirtualBox or Hyper-V
**Start a Kubernetes cluster**  
Once the VM is running, go to *Control Panel -> Administrative Tools -> Hyper-V Manager -> Virtual Machines -> minikube* and double-click on **minikube** to connect to the newly created VM (**minikube**); use **docker** for username and **tcuser** for the password.
>`>` minikube start --vm-driver=hyperv

**If the installation fails, debug it with**
>`>` minikube delete  
>`>` minikube start --vm-driver=hyperv --v=7 --alsologtostderr

**IP address of cluster**
>`>` minikube ip

**Context**
>`>` minikube config current-context

**Status of the cluster**
>`>` minikube status

**Visit the official Kubernetes dashboard**
>`>` minikube dashboard

# Kubernetes
## Notes
1. ddd

**Display the *kubectl* (Kubernetes client) version**
>`>` kubectl version --client --short  
>`>` kubectl version --client -o="yaml"  
>`>` kubectl version --client -o="json"

**Display the client (*kubectl*) and server versions**
>`>` kubectl version --short  
>`>` kubectl version -o="yaml"  
>`>` kubectl version -o="json"

# Cluster
### Cluster information
>`>` kubectl cluster-info

# Nodes
### Listing
**Cluster nodes**
>`>` kubectl get nodes

**Additional details**
>`>` kubectl describe node [node-name]

**Additional details for all nodes**
>`>` kubectl describe node

# Deployment
### Creation
The command-line option --record records the command in the revision history.
>`>` kubectl create -f [file-name].yaml --record

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

# Pods
## Notes
1. Kubernetes assigns an IP address to a pod after the pod has been scheduled to a node and before it is started.

### Creation
**Create a pod**
>`>` kubectl create -f filename.yaml

### Deletion
When a *pod* is deleted, Kubernetes will terminate all of the containers that are part of the pod. Kubernetes sends a SIGTERM signal to the main process in the container and waits up to thirty (30) seconds for the main process to stop. If the main process doesn't comply with the request within the timeout period, Kubernetes sends a SIGKILL. Whereas the main process can ignore a SIGTERM, the SIGKILL goes straight to the kernel thereby terminating the main process; the main process is forcibly killed without having an opportunity to exit gracefully. To ensure a gracefully exit, the main process needs to handle the SIGTERM signal.

**Delete a pod by name**
>`>` kubectl delete po [pod-name]

**Delete *pods* using labels**
>`>` kubectl delete po -l [label-name]=[label-value]

**Delete *pods* by deleting a namespace**
>`>` kubectl delete ns [namespace-name]

**Delete *all pods* in a namespace; keep the namespace**
>`>` kubectl delete po --all

### Executing commands
**Execute commands in a running container**  
The double dash (--) in the command signals the end of command options for *kubectl*; all that follow the double dash is the command that should be executed inside the pod. If the command has no arguments that start with a dash, the double dash isn’t necessary.
>`>` kubectl exec [pod-name] -- curl -s http://[IP-address-of-pod]

**List environment variables**
>`>` kubectl exec [pod-name] env

**Running a shell**  
The shell must be available in the container image.
>`>` kubectl exec -it [pod-name] powershell

### IP addresses and ports
>`>` kubectl describe pod [pod-name] | Select-String -Pattern IP:  
>`>` kubectl describe pod [pod-name] | Select-String -Pattern Port:

### Labels
#### Notes
1. Labels are a Kubernetes feature for organizing **all** Kubernetes resources. A resource may have more than one label as long as the keys of the labels are unique within the resource.

**Add labels to pods managed by a ReplicationController**
>`>` kubectl label pod [pod-name] [label-name]=[label-value]  
>`>` kubectl label po [pod-name] [label-name]=[label-value]  

**Change the labels of a managed pod**
>`>` kubectl label pod [pod-name] [label-name]=[label-value] --overwrite  
>`>` kubectl label po [pod-name] [label-name]=[label-value] --overwrite

**List specific labels in their own columns**
>`>` kubectl get pods -L [label-name]
>`>` kubectl get po -L [label-name],[label-name]

**List labels**
>`>` kubectl get pods --show-labels
>`>` kubectl get po --show-labels

**List pods using label selectors** 
Display all pods with [label-name]=[label-value]
>`>` kubectl get po -l [label-name]=[label-value]

Display all pods that include the [label-name] label
>`>` kubectl get po -l [label-name]

Display all pods that do not include the [label-name] label
>`>` kubectl get po -l '![label-name]'

Display all pods where [label-name]!=[label-value]
>`>` kubectl get po -l [label-name]!=[label-value]

Display all pods where [label-name] is either [label-value1] or [label-value2]
>`>` kubectl get po -l [label-name] in ([label-value1], [label-value2])

Display all pods where [label-name] is not either [label-value1] or [label-value2]
>`>` kubectl get po -l [label-name] notin ([label-value1], [label-value2])

### Logging
**Retrieve the log of a pod**  
Container logs are automatically rotated daily and every time the log file reaches 10MB in size.
>`>` kubectl logs [pod-name]

**Retrieve the log of a crashed container**  
If the container is restarted, the command will show the log of the restarted container.
>`>` kubectl logs [pod-name] --previous

**Retrieve the log of a specific container from a multi-container pod**  
To retrieve a container log, its pod needs to exist. When a pod is deleted, its logs are also deleted.
>`>` kubectl logs [pod-name] -c [container-name]

### Listing, explaining, describing
**List pods (individual containers cannot be listed since they're not standalone Kubernetes objects)**
>`>` kubectl get pods  
>`>` kubectl get pod [pod-name]

**Detail explanation of an object and its attributes**
>`>` kubectl explain pods  
>`>` kubectl explain pod.spec

**Describe a pod**  
To see the reason the previous container terminated, check the Exit Code. The exit code is the sum of two numbers: 128 + x, where x is the signal number sent to the process that caused it to terminate. For example, an exit code of 137 equals 128 + 9 (SIGKILL); likewise, an exit code of 143 equals 128 + 15 (SIGTERM).
>`>` kubectl describe pod [pod-name]  
>`>` kubectl describe po [pod-name]

**Retrieve full description of running pod**
>`>` kubectl get pod [pod-name] -o yaml  
>`>` kubectl get po [pod-name] -o yaml  
>`>` kubectl get po [pod-name] -o json

### Namespaces
**List pods in the given namespace**
>`>` kubectl get po --namespace [namespace-name]  
>`>` kubectl get po -n [namespace-name]

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

**From Minikube**
>`>` minikube dashboard





The app itself needs to support being scaled horizontally. Kubernetes doesn't make an app scalable; it only supports scaling the app up or down.

A base image is the root Operating System (OS) filesystem. The base image uses the OS kernel from the host. Because the OS could bring with it vulnerabilities, it is best practice to keep the base image as minimal as possible.


kubectl run rmq --image=jctrimino/rabbitmq-3.8.1-erlang-22.1:windowsserver-1903 --port=15672 --port=5672 --generator=run-pod/v1


