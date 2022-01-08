***
# Theorems, methodologies, et al.
## [CAP Theorem](https://en.wikipedia.org/wiki/CAP_theorem)
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

## [The Twelve-Factor App](https://12factor.net/)
A methodology for building `Software-as-a-Service` applications.

<br>

***
# Tools
## [Base64](https://www.browserling.com/tools/file-to-base64)
Convert a binary file to a base64-encoded text file.<br>

Base64 Encode and Decode<br>
https://base64.guru/converter/decode/file<br>
http://www.base64decode.org

<br>

## [curl](https://curl.se/)
Command line tool and library.

## [curl options](https://gist.github.com/eneko/dc2d8edd9a4b25c5b0725dd123f98b10)
List of curl options.

<br>

## [JSON](https://jsonformatter.curiousconcept.com)
JSON Formatter and Validator<br>

## [JSONLint](https://jsonlint.com)
JSON Validator<br>

<br>

## [JSON Web Token (JWT)](http://jwt.io) [[RFC 7519]](https://www.ietf.org/rfc/rfc7519.txt)
Decode, verify, and generate JWT.<br>

<br>

## [JSON Web Key (JWK) [RFC 7517]](https://www.ietf.org/rfc/rfc7517.txt)
A JWK is a JSON representation of a cryptographic key.<br>

JWK to PEM Converter.<br>
https://8gwifi.org/jwkconvertfunctions.jsp

<br>

## [Privacy Enhanced Mail (PEM)](https://report-uri.com/home/pem_decoder)
Decode a PEM file.<br>

<br>

***
# [Minikube](https://kubernetes.io/docs/setup/minikube/)
Setup a single-node K8s cluster on a local machine.<br>

#### Notes
1. Minikube runs Kubernetes inside a Virtual Machine (VM) run through either VirtualBox or Hyper-V.
2. Minikube will only run Linux based containers.
3. Since Minikube doesn't support *`LoadBalancer`* services, services will never get an external IP.

### Cluster
**Start a K8s cluster (Windows).**<br>
Once the VM is running, go to *`Control Panel -> Administrative Tools -> Hyper-V Manager -> Virtual Machines -> minikube`* and double-click on *`minikube`* to connect to the newly created VM (**minikube**); use **docker** for username and **tcuser** for the password.
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
# [Docker Desktop](https://docs.docker.com/desktop/)
Setup a single-node K8s cluster on a local machine.

**Display the current context.**
>`\>` kubectl config current-context

**Change the current context to docker-for-desktop.**
>`\>` kubectl config use-context docker-for-desktop

<br>

***
# [Kubernetes (K8s)](https://kubernetes.io/docs/) - Greek for "helmsman" or "pilot"
K8s is an orchestration service that simplifies the deployment, management, and scaling of containerized applications. K8s is composed of master nodes and worker nodes; the nodes can be either physical servers or VMs. Users of K8s interact with the master nodes using either a CLI (`kubectl`), an API, or a GUI.<br>
A container orchestration is *an abstraction over the network*.

## Architecture Overview
K8s uses the *`client-server architecture`*. A K8s cluster consists of one or more master nodes and one or more worker nodes.

<br>

### Master Node (Control Plane)
The master node controls and manages the cluster and consists of four main components:
1. *`API Server`* exposes the K8s API and provides the frontend to the cluster's shared state through which all other components interact.
   1. It is the central component used by all other components and clients (e.g., kubectl, scheduler); K8s system components communicate only with the API server.
   2. It provides a CRUD (Create, Read, Update, Delete) interface for querying and modifying the cluster state over a RESTful API.
   3. It uses etcd to store the state and is the only component that communicates with etcd.
2. *`Scheduler`* schedules the apps by assigning a worker node to each deployable component of the app.
   1. It monitors the API server's watch mechanism and assigns a cluster node to the new pod.
   2. It updates the pod definition through the API server. The API server notifies the Kubelet (using the watch mechanism) that a pod has been scheduled. When the Kubelet on the target node receives the notification, it creates and runs the pod's containers.
   3. By default, pods belonging to the same Service or ReplicaSet are distributed across multiple nodes, but this is not always guaranteed.
   4. A cluster may have multiple Schedulers running, and a pod may specify the Scheduler that should schedule it by setting the *schedulerName* property in the pod spec. Pods without the *schedulerName* property set or with the *schedulerName* property set to *default-scheduler* are scheduled using the default Scheduler; all other pods are ignored by the default Scheduler.
   5. The scheduler looks at *allocatable resources* minus *allocated resources* to find available resources. Allocatable resources are the resources that can be consumed by pods on a worker node. In Kubernetes, the allocatable resource quantity for a worker node is defined by the total resource available in the node minus the capacity that is reserved for system daemons and [Kubernetes runtime components](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/).
   6. Pod Priority and Preemption
      1. If a pod with resource needs that cannot be met requires to be scheduled, the scheduler can evict lower-priority pods to free resources for the higher-priority pod.
      2. If a high-priority pod and a low-priority pod are both pending, the low-priority pod will not be scheduled until the high-priority pod is running.
      3. Pod priority affects preemption during scheduling but does not affect the eviction algorithms.
   7. Pod Quality of Service (QoS)
      1. QoS is the intersection of requests and limits; it does not have any impact on scheduling. However, QoS does determine the pod eviction selection process.
      2. Resources are defined as `compressible and incompressible`.
         - Nonshareable resources (RAM, disk, et al.) are known as `incompressible`; when there is competition for RAM or disk, processes will be evicted to free RAM or disk for other processes.
         - Shareable resources (CPU, et al.) are known as `compressible`; that is, CPU can be compressed (split) to allow multiple processes to compete for CPU cycles.
      3. Pod QoS Levels
         - `Guaranteed` is the highest level; pods that have their resource requests and limits set to the same value for all resources.
           ```
           resources:
             limits:
               memory: "400Mi"
             requests:
               memory: "400Mi"
           ```
         - `Burstable` pods have requests set, but their limit values are higher, which permits them to consume more resources if needed.
           ```
           resources:
             limits:
               memory: "600Mi"
             requests:
               memory: "400Mi"
           ```
         - `BestEffort` pods have no requests or limits set.
           ```
           resources: {}
           ```
      4. `K8s` uses QoS to determine which pod to kill. If a worker node comes under resource pressure, `BestEffort` pods are killed first, then `Burstable`, and then `Guaranteed`. But for a `Guaranteed` pod to be evicted from a node, it would require some system-level resource pressures.
      5. Since QoS is defined on a container-by-container basis and is under the `developer's control`, there is an opportunity to achieve higher resource utilization without putting the critical containers at risk of being starved for resources or potentially having their performance diminished. Hence, the developers' configuration of resource requests and limits will have a significant impact on how the cluster behaves and handles pods.
      6. Debugging the workloads and managing capacity is difficult if using anything other than `Guaranteed` QoS.
      7. **`Avoid`** the use of `BestEffort` QoS in **production**; it can result in very unpredictable scheduling due to an environment that may be very unstable as pods compete for resources.
3. *`Controller Manager`* performs cluster-level functions such as replicating components, keeping track of worker nodes, etc.
   1. The Controller Manager process embeds the *core control loops* (controllers); e.g., Node Controller, Enpoints Controller, Namespace Controller, et al.
   2. It ensures that the *actual state* of the system converges toward the *desired state* by watching the API Server for changes to resources.
   3. Controllers do not communicate with each other directly; each controller connects to the API Server and monitors the watch mechanism.
4. *`etcd`* is a key:value distributed data store (see [CAP Theorem](#cap-theorem)) that persistently stores the cluster configuration.
   1. It is the only place K8s stores cluster state and metadata.
   2. The API server is the only component that talks to etcd directly.
   3. Prior to K8s version 1.7, the JSON manifest of a *Secret* resource was stored as clear text. From version 1.7, Secrets are encrypted.
   4. A key feature of `etcd` is its ability to support a `watch`. A `watch` is a `remote procedure call (RPC)` mechanism that allows for callbacks to functions on key-value create, update, or delete operations.

<br>

### Worker Node
K8s runs workloads (containers) on worker nodes; a worker node consists of three main components:
1. *`Kubelet`* communicates with the API Server and manages containers running in a Pod on its node.
   1. The `kubelet` is responsible for ensuring that the containers in each pod are created and running.
   2. The `kubelet` will restart containers upon recognizing that they have terminated unexpectedly or failed some user defined health checks.
2. *`K8s Service Proxy (Kube-Proxy)`* load-balances network traffic between application components.
   1. The `Kube-proxy` gives a distributed load-balancing capability that is critical to the high availability architecture of Kubernetes.
   2. It tracks changes to the endpoints of all services in order to keep `iptables` or `IP Virtual Server (IPVS)` configurations up to date.
3. *`Container Runtime`* runs the containers that exist in each pod. K8s supports several container runtime environments; e.g., Docker, rkt, CRI-O.

<br>

***
# [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
## Notes
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

## [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)
**Get all nodes in the cluster.**
>`\>` kubectl get nodes

**Get additional details for given node.**
>`\>` kubectl describe node [node-name]

**Get additional details for all nodes.**
>`\>` kubectl describe node

<br>

## Objects
### Status
**List all possible object types.**
>`\>` kubectl get

<br>

## [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
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

## [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
### Notes
1. Pods represent the basic `deployable unit` in `K8s`; pods are the unit of `horizontal scaling`.
2. `K8s` assigns an IP address to a pod after the pod has been scheduled to a node and before it is started.
3. As soon as a pod is scheduled to a node, the Kubelet on that node will run its containers, and it will keep them running as long as the pod exists. If a container's main process crashes, the Kubelet will restart the container.
4. Pods are ephemeral -- they can come and go at any time for all sort of reasons such as scaling up and down, failing container health checks, node migrations, etc. As such, a pod’s network address may change over the life of an application thereby requiring another primitive for discovery and load balancing; this primitive is the `Service`.
5. Since containers are not standalone K8s objects, they can't be listed individually.
6. It's common for a pod to contain only a single container, but when a pod contains multiple containers, all of them are run on a single worker node.
7. If a pod contains multiple containers, the scheduler needs to find a worker node that has enough resources to satisfy all container demands combined.
8. Because most of the container's filesystem comes from the container image, the filesystem of each container, by default, is fully isolated from other containers. But it is possible to have containers share file directories using *Volume*.
9. Container logs are automatically rotated daily and every time the log file reaches 10MB in size. Note that container logs can only be retrieved from running pods. Once a pod is deleted, its logs are also deleted.
10. Containers located in the same pod communicate with one another using standard interprocess communication (IPC) mechanisms.
11. When a pod is deleted, K8s terminates all of the containers that are part of the pod. K8s sends a SIGTERM signal to the main process of the container and waits a certain number of seconds, 30 is the default, for the main process to shut down gracefully. If it doesn't shut down in the given time, K8s sends a SIGKILL to the Operating System (OS), and the OS kills it. To ensure processes are always shut down gracefully, they need to handle the SIGTERM signal properly.
12. To see the reason the previous container terminated, check the Exit Code. The exit code is the sum of two numbers: 128 + x, where x is the signal number sent to the process that caused it to terminate. For example, an exit code of 137 equals 128 + 9 (SIGKILL); likewise, an exit code of 143 equals 128 + 15 (SIGTERM).

### Listing
**List the pods in the given namespace.**
>`\>` kubectl get pods -n [namespace-name]

**List all running pods across all namespaces**
>`\>` kubectl get pods --all-namespaces

**List pods using a label selector.**
>`\>` kubectl get pod -l [label-name]

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
>`\>` kubectl create -f filename.yaml

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
>`\>` kubectl exec [pod-name] -- curl -s http://[IP-address-of-pod]

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

## [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
### Notes
1. A service is a resource that creates a single point of entry to a group of pods providing the same service. When a service is created, it gets a static IP, which never changes during the lifetime of the service. Hence, clients should connect to the service through its static IP address and not to pods directly (pods are ephemeral). The service ensures one of the pods receives the connection, regardless of the pod's current IP address.
2. Services deal with TCP and UPD packets.
3. Label selectors determine which pods belong to a Service.
4. A service forwards each connection to a randomly selected backing pod. To redirect all requests made by the same client to the same pod, set the service's *spec.sessionAffinity* property to ClientIP (the default is None). The session affinities supported by Kubernetes are: **None** and **ClientIP**.
5. When a service exposes multiple ports, each port must be given a name. All of the service's ports will be exposed through the service cluster IP.
6. The service *`fully qualified domain name (FQDN)`*<br>
   svc-name.default.svc.cluster.local<br>
   svc-name = service name<br>
   default = namespace the service is defined in<br>
   svc.cluster.local = a configurable cluster domain suffix used in all cluster local service names.
7. For a Service of the LoadBalancer type to work, K8s uses an external load balancer.
8. K8s supports two (2) primary modes to discover a service.
   - Environment variables - When a pod is created, `kubelet` adds a set of environment variables for each active service. (A service must be created before the pods; otherwise, the pods will not have the environment variables for the service. If the DNS is used instead, then there is no need to worry about this ordering issue.)
   - DNS - A cluster-aware DNS server, such as `CoreDNS`, watches the K8s API for new Services and creates a set of DNS records for each one. If DNS has been enabled throughout the cluster, then all Pods should automatically be able to resolve Services by their DNS name.

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

### Services and Environment Variables
When a pod is started, K8s initializes a set of environment variables for each service that exists at that moment. If a service is created before the pods are created, processes in the pods can get the IP address and port of the service by inspecting its enviroment variables.<br>

**List environment variables inside an existing container by running the *env* command**<br>
The name of the environment variables for a given service will be:<br>
[service-name]_SERVICE_HOST=`xxx.xxx.xxx.xxx`<br>
[service-name]_SERVICE_PORT=`xxxxx`<br>

Note that dashes in the service name are converted to underscores and all letters are uppercased.
>`\>` kubectl exec [pod-name] -- env

### Services and DNS
K8s includes a DNS server for use in service discovery; *CoreDNS* is the recommended DNS Server, replacing *Kube-DNS* as of v1.12. K8s assigns each service a virtual static IP address within the cluster (ClusterIP) and generates an internal DNS entry that resolves to this IP address; any request that reaches this IP address will be routed to one of the pods in the group. In general, K8s services support A, CNAME, and SRV records. K8s assigns A records to services of the form `service-name.namespace-of-service.svc.cluster.local`.

List all pods in the *kube-system* namespace; one of the pods is called *`*dns*`*.
>`\>` kubectl get pods -n kube-system

As its name suggests, the pod *`*dns*`* runs a DNS server; K8s modifies each container's */etc/resolv.conf* file to ensure that all other pods running in the cluster are automatically configured to use the DNS server. Since the DNS server knows all of the services running in the cluster, any DNS query performed by a process running in a pod will be handled by the DNS server. Because each service gets a DNS entry in the DNS server pod, a pod that knows the name of the service can access it through its FQDN. Finally, whether a pod uses the DNS server or not is determined by the *dnsPolicy* property in each pod's spec.

Use the *kubectl exec* command to run a shell.<br>
*(The shell must be available in the container image.)*
>`\>` kubectl exec -it [pod-name] [shell]<br>

Once inside the container, use the *curl* command to access the service by using one of the following:
*(The curl command must be available in the container image.)*
>`\>` curl http://[service-name].[namespace-of-service].svc.cluster.local<br>
>`\>` curl http://[service-name].[namespace-of-service]<br>
>`\>` curl http://[service-name]<br>

Display the /etc/resolv.conf file in the container to see how the DNS resolver inside each pod's container is configured.<br>
>`\>` cat /etc/resolv.conf

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

## [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
### Notes
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

## [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
### Notes
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

## [ReplicationController](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/) (Deprecated instead use [ReplicaSet](#replicaset))

<br>

## Service Accounts
### Notes
1. K8s uses two types of accounts for *`authentication`* and *`authorization`*: *`user accounts`* and *`service accounts`*. While K8s creates and manages service accounts, user accounts are not created or managed by K8s.
2. A service account provides an identity to a pod, and K8s uses the service account to authenticate a pod to the API server.
3. K8s binds each pod to a service account; multiple pods can be bound to the same service account, but a pod can be bound to exactly one service account. That is, when a K8s namespace is created, by default K8s creates a service account called *`default`*. This service account is assigned to all the pods that are created in the namespace, unless a pod is created under a specific service account.
4. A pod can only be bound to a service account from the same namespace.
5. A namespace contains its own default service account, but additional service accounts can be created, if necessary.
6. By default, at the time a K8s cluster is created, K8s creates a service account for the `default` namespace.
7. At the time of creating a service account, K8s creates a token secret and attaches it to the service account. All pods bound to this service account can use the token secret to authenticate to the API server. (The authentication tokens used in service accounts are JSON Web Tokens (JWT).)
   1. Every mounted secret means another watch on that secret for the `kubelet`. In aggregate, these secret watches can have a significant impact on `etcd/apiserver` performance and scale. The workload for the `apiserver` is reduced because the `kubelet` will not need to call the `apiserver` to get the token; the node performance is improved because there are fewer volume mounts for tokens. To skip mounting the service account token into the pod:
   ```
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: no-mount
   automountServiceAccountToken: false
   ```

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

## [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
### Notes
1. DaemonSet runs only a single pod replica on each node.
2. Because DaemonSet bypasses the Scheduler, it can deploy pods to nodes that have been made un-schedulable, which prevents pods from being deployed to them.

<br>

## [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
### Notes
1. `PersistentVolumes` are cluster-level resources like nodes; hence, they do not belong to any namespace.
2. `PersistentVolumeClaims` must be created in a namespace; they can be used only by pods in the same namespace.
3. The `PersistentVolumes` and `PersistentVolumeClaims` resources were introduced to enable apps to request storage in a `K8s` cluster without having knowledge of the actual network storage infrastructure/technology.
4. `PersistentVolumes` are provisioned by cluster admins and consumed by pods through `PersistentVolumeClaims`.
5. Storage can be provisioned `statically` or `dynamically`.
   - Static provisioning means that the cluster administrator creates the persistent volumes manually. Administrators create the persistent volumes of a type that matches the site-specific storage solution.
   - Dynamic provisioning uses storage classes to create persistent volumes on demand.
6. StorageClass can be used to automatically provision persistent volumes.
7. `StorageClass` resources are cluster-level resources like `PersistentVolumes`; hence, they do not belong to any namespace.

Display all `PersistentVolume` objects in a cluster.
>`$` kubectl get pv

To see the `YAML` definition for a given `PersistentVolume`.
>`$` kubectl get pv [pv-name] -o yaml

To add a `PersistentVolume` object to a cluster.<br>
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-openssl
spec:
  capacity:
    storage: 10Mi
  accessModes:
  - ReadWriteOnce
  - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  # The PersistentVolume backed by a persistent disk.
```
>`$` kubectl create -f [pv-definition-filename].yaml

Display all `PersistentVolumeClaim (PVC)`.<br>
The abbreviations used for the `access modes` are:
- RWO (ReadWriteOnce) - Only a single `node` can mount the volume for reading and writing.
- ROX (ReadOnlyMany) - Multiple `nodes` can mount the volume for reading.
- RWX (ReadWriteMany) - Multiple `nodes` can mount the volume for reading and writing.

The abbreviations RWO, ROX, RWX pertain to the **number of worker nodes** that can use the volume at the same time.
>`$` kubectl get pvc

Create a `PersistentVolumeClaim` object to request a dedicated storage resource from the cluster pool. As soon as the claim is created, `K8s` finds the appropriate `PersistentVolume` and binds it to the claim.
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-openssl
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Mi
```
>`$` kubectl create -f [pvc-definition-filename].yaml

If the pod and the `PersistentVolumeClaim` are deleted, what will happen if the `PersistentVolumeClaim` is created again?
>`$` kubectl delete pod [pod-name-or-id]<br>
>`$` kubectl delete pvc [pvc-name-or-id]

When the claim was created earlier, it was bound to the `PersistentVolume` immediately, but not now. If the command below is executed, the STATUS column will show *Pending*.
>`$` kubectl get pvc

If the command below is executed, the STATUS column will show *Released*, and not *Available* like it would have been the first time. Since the volume has been used, it may contain data and should not be bound to a new claim without being clean up first. Otherwise, a new pod using the same `PersistentVolume` may read the data stored there by the previous pod. This is the behaviour of the `Retain` policy in `PersistentVolume`. (Two other reclaim policies exist: `Recycle` and `Delete`.)
>`$` kubectl get pv

To define a `StorageClass`.<br>
The cluster administrator creates the storage classes with different performances or characteristics.
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: disk-openssl
provisioner: kubernetes.io/[provisioner-name]
parameters:
  type: [type-name]
  zone: [zone-name]
```

To request the storage in a `PersistentVolumeClaim`.
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-openssl
spec:
  storageClassName: disk-openssl
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Mi
```

To display storage classes.
>`$` kubectl get [storageclass | sc]

The `default storage class`.<br>
The `default storage class` is used to dynamically provision a `PersistentVolume` when the `PersistentVolumeClaim` does not explicitly define which storage class to use.<br>
Setting `storageClassName: ""` ensures the PVC binds to a pre-provisioned PV.
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-openssl
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Mi
```
>`$` kubectl get sc standard -o yaml

<br>

## [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
### Notes
1. Use `ConfigMap` to decouple an app's configuration from the app's source code.
2. A key must be a valid DNS subdomain; i.e., it may only contain alphanumeric characters, dashes, underscores, and dots. It may optionally include a leading dot.
3. The contents of a ConfigMap's entries are shown in clear text.
4. If the referenced `ConfigMap` doesn't exist when the pod is created, `K8s` schedules the pod and tries to run its containers. The container referencing the non-existing `ConfigMap` will fail to start, but the other constainers will start. If the missing `ConfigMap` is created later, the failed container is started without recreating the pod. If the `ConfigMap` is set to optional (`configMapKeyRef.optional: true`), then the container starts even if the `ConfigMap` doesn't exist.

### Creation
To pass literals.
>`$` kubectl create configmap [config-file-name] --from-literal=one=1 --from-literal=two=2

From a file (yaml).
>`$` kubectl [create | apply] -f [config-file-name].yaml

Create a `ConfigMap` entry from the contents of a file.<br>
When the command below is executed, `kubectl` searches for the given file in the directory it is running. The contents of the file are stored under the key [config-file-to-convert-to-an-entry.ext] (the filename is used as the map key) in the `ConfigMap`.
>`$` kubectl create configmap [config-file-name] --from-file=[config-file-to-convert-to-an-entry.ext]

To use a different key for the contents of the file.
>`$` kubectl create configmap [config-file-name] --from-file=[key-name]=[config-file-to-convert-to-an-entry.ext]



### Listing
List all configmaps available in the current K8s namespace.
>`\>` kubectl get configmaps

To diplay definition.
>`\>` kubectl get configmap [config-file-name] -o yaml

<br>

## [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)
### Notes
1. The maximum size of a `Secret` is limited to 1MB.
2. The contents of a Secret's entries are shown as Base64-encoded strings.
3. A Secret's entries can contain plain-text (`stringData`) or binary value (`data`).
4. The `stringData` field is *write-only*.
5. Because how K8s handles Secrets internally, always use **Secret** over **ConfigMap** to store sensitive data. K8s ensures that Secrets are only accessible to the Pods that need them, and Secrets are never written to disk; Secrets are kept in memory. K8s writes Secrets to disk only at the master node, where all Secrets are stored in etcd. etcd is the distributed key/value database use by K8s, and since K8s 1.7+, etcd stores Secrets only in an encrypted format.
6. K8s mounts a `Secret` to each container in a Pod; this is called the *`default token secret`*. To disable the mounting, set the `automountServiceAccountToken` field to `false` in the pod spec or the service account the pod is using.
7. The `default token secret` has three name/value pairs under the `data` element in base64-encoded format: `ca.crt`, `namespace`, and `token`.
8. The value of `ca.crt` is the root certificate of the K8s cluster.
9. The `token` carries a JSON Web Token (JWT).
10. Each container in a K8s Pod has access to this JWT from its filesystem in the directory /var/run/secrets/kuberenetes.io/serviceaccount. This JWT is bound to a K8s service account; e.g., to access the K8s API server from a container, use this JWT for authentication.

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

***
# Red Hat OpenShift Container Platform (RHOCP)
`Red Hat` provides its own distribution of `K8s` that it refers to as `OpenShift`; `Red Hat OpenShift Container Platform` is a set of modular components and services built on top of `Red Hat CoreOS` and `K8s`. RHOCP adds `Platform as a Service (PaaS)` capabilities such as remote management, increased security, monitoring and auditing, application life-cycle management, and self-service interfaces for developers. An `OpenShift cluster` is a `K8s cluster` that can be managed the same way, but by using the management tools provided by `OpenShift`, such as the command-line interface (CLI) or the web console.

## OpenShift Container Platform Stack
1. The base OS is `Red Hat CoreOS`; Red Hat CoreOS is a Linux distribution focused on providing an immutable operating system for container execution.
2. [CRI-O](https://cri-o.io/) is an implementation of the `K8s CRI (Container Runtime Interface)` to enable using `OCI (Open Container Initiative)` compatible runtimes. `CRI-O` can use any container runtime that satisfies `CRI`: `runc` (`Docker`), `libpod` (`Podman`) or `rkt` (`CoreOS`).
3. `K8s` manages a cluster of nodes, physical or virtual, that run containers. It uses resources that describe multicontainer applications composed of multiple resources, and how they
interconnect.
4. `etcd` is a distributed key-value store, used by `K8s` to store configuration and state information about the containers and other resources inside the `K8s` cluster.
5. `Custom Resource Definitions (CRDs)` are resource types stored in `etcd` and managed by `K8s`. These resource types form the state and configuration of all resources managed by
`OpenShift`.
6. Containerized services fulfill many `PaaS` infrastructure functions, such as networking and authorization. `RHOCP` uses the basic container infrastructure from `K8s` and the underlying container runtime for most internal functions; i.e., most `RHOCP` internal services run as containers orchestrated by `K8s`.
7. Runtimes and xPaaS are base container images ready for use by developers, each preconfigured with a particular runtime language or database. The xPaaS offering is a set of base images for `Red Hat` middleware products such as `JBoss EAP` and `ActiveMQ`. `Red Hat OpenShift Application Runtimes (RHOAR)` are a set runtimes optimized for cloud native applications in `OpenShift`. The application runtimes available are `Red Hat JBoss EAP`, `OpenJDK`, `Thorntail`, `Eclipse Vert.x`, `Spring Boot`, and `Node.js`.
8. DevOps tools and user experience: `RHOCP` provides web UI and CLI management tools for managing user applications and `RHOCP` services. The `OpenShift` web UI and CLI tools are built from REST APIs which can be used by external tools such as IDEs and CI platforms.

## K8s Resource Types
`K8s` has six main resource types that can be created and configured using a YAML or JSON file or using `OpenShift` management tools.
1. `Pods (po)` represent a collection of containers; it is the basic unit of work for `K8s`.
2. `Services (svc)` define a single IP/port combination that provides access to a pool of pods. By default, services connect clients to pods in a round-robin fashion.
3. `Replication Controllers (rc)` define how pods are replicated (horizontally scaled) into different nodes. Replication controllers are a basic K8s service to provide high availability for pods and containers.
4. `Persistent Volumes (pv)` define storage areas to be used by `K8s` pods.
5. `Persistent Volume Claims (pvc)` represents a request for storage by a pod. PVCs links a PV to a pod so its containers can make use of it, usually by mounting the storage into the container's file system.
6. `ConfigMaps (cm)` and `Secrets` contain a set of keys and values that can be used by other resources. ConfigMaps and Secrets are usually used to centralize configuration values used by several resources. Secrets differ from ConfigMaps maps in that Secrets' values are always **`encoded (not encrypted)`** and their access is restricted to fewer authorized users.

## OpenShift Resource Types
The main resource types added by `OpenShift Container Platform` to `K8s`.
(To obtain a list of all the resources available in a `RHOCP cluster` and their abbreviations, use the **`oc api-resources`** or **`kubectl api-resources`** commands.)
1. `Deployment config (dc)` represents the set of containers included in a pod, and the deployment strategies to be used. A dc also provides a basic but extensible continuous delivery workflow.
2. `Build config (bc)` defines a process to be executed in the `OpenShift` project. Used by the `OpenShift Source-to-Image (S2I)` feature to build a container image from application source code stored in a Git repository. A bc works together with a dc to provide a basic but extensible continuous integration and continuous delivery workflows.
3. `Routes` represent a `DNS` host name recognized by the `OpenShift` router as an ingress point for applications and microservices.

<br>

***
# [oc](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html)
## Notes
1. Because the `OpenShift` distribution of `K8s` adds several new features beyond those used by `K8s`, `OpenShift` provides access to these features by extending the capabilities of `kubectl`. To access these features, `OpenShift` uses its own CLI tool named **`oc`**; in addition of supporting these features, this tool provides one-to-one matching support for all `kubectl` commands. Thus, the following commands are equivalent:
   >`$` kubectl apply -f test1.yaml<br>
   >`$` oc apply -f test1.yaml
2. `OpenShift` introduces several new concepts to simplify development and operations. These new concepts are: authentication, jct

## Version
To check the versions.
>`$` oc version

## Current Session
To return currently authenticated user name or empty string.
>`$` oc whoami<br>

or (PowerShell)
>`$` $token=$(oc whoami -t)<br>
>`$` oc whoami $token

or (Linux)
>`$` export token=\$(oc whoami -t)<br>
>`$` oc whoami $token

To display URL of console.
>`$` oc whoami --show-console

To find the URL of the console pod (requires the `OpenShift` DNS).
>`$` oc get routes -n openshift-console

To display token current session is using.
>`$` oc whoami --show-token

$ token=$(oc whoami -t)
# get the owner of the token


## Authentication
All users **must authenticate** with the cluster to be able to access it. `OpenShift` supports common authentication methods such as basic authentication with username and password, OAuth access token, X.509 client certificates.

The `OpenShift` installer creates the directory `auth` containing the `kubeconfig` and `kubeadmin-password` files. Run the `oc login` command to connect to the cluster with the user `kubeadmin` and the password located in the `kubeadmin-password` file.

The user will be asked to enter the `OpenShift Container Platform` server URL and whether or not secure connections are needed, and then the user will be asked to input its username and password.
>`$` oc login

>`$` oc login -u [username] -p [password] [URL:port]<br>
>`$` oc login --username [username] --password [password] [URL:port]

>`$` oc login --token=[token] --server=[URL:port]

**Log out** of the active session.
>`$` oc logout

## Cluster Version Resource
`ClusterVersion` is a custom resource that holds high-level information about the cluster; use this resource to declare the version of the cluster to run. Defining a new version for the cluster instructs the `cluster-version` operator to upgrade the cluster to that version.<br>
To retrieve the cluster version.
>`$` oc get clusterversion

To obtain more detailed information about the cluster status.
>`$` oc describe clusterversion

## Health of OpenShift Nodes
To display a column with the status of each node. If a node is not `Ready`, it cannot communicate with the OpenShift control plane and is effectively dead to the cluster.
>`$` oc get nodes

To display the current CPU and memory usage of each node. These are actual usage numbers.
>`$` oc adm top nodes

To display the resources available and used from the scheduler point of view.
>`$` oc describe node [node-name-or-IP-address]

## Cluster Operators
`OpenShift Container Platform` cluster operators are top level operators that manage the cluster. They are responsible for the main components, such as the API server, the web console, storage, or the SDN; their information is accessible through the `ClusterOperator` resource.<br>
To retrieve the list of all cluster operators.
>`$` oc get clusteroperators

## Logs of OpenShift Nodes
Most of the infrastructure components of `OpenShift` are containers inside pods; their logs can be viewed the same way as regular containers. Some of these containers are created by the `Kubelet`, and thus invisible to most distributions of K8s, but `OpenShift` cluster operators create pod resources for them.

An OpenShift node based on `Red Hat Enterprise Linux CoreOS` runs very few local services that would require direct access to a node to inspect their status. Most of the system services in Red Hat Enterprise Linux CoreOS run as containers. The **main exceptions** are the `CRI-O container engine` and the `Kubelet`, which are **systemd units**.<br>
To view these logs.
>`$` oc adm node-logs -u crio [node-name-or-IP-address]<br>
>`$` oc adm node-logs -u kubelet [node-name-or-IP-address]

To display all journal logs of a node.
>`$` oc adm node-logs [node-name-or-IP-address]

## APIs
`OpenShift` resources can be defined in a declarative way in YAML files.

Version of the APIs.
>`$` oc api-version

Diplay resources as defined in the API.
>`$` oc api-resources | less

To explore what is in the APIs.
>`$` oc explain [--recursive]

## New Project/Application
### Notes
1. In `OpenShift 4.5`, by default, the `oc new-app` command produces `Deployment` resources instead of `DeploymentConfig` resources. To create `DeploymentConfig` resources, pass the `--as-deployment-config` flag when invoking `oc new-app`.
2. The `oc new-app` command can be used with the `-o json` or `-o yaml` option to create a skeleton resource definition file in `JSON` or `YAML` format, respectively.

### [Projects](https://docs.openshift.com/container-platform/4.7/applications/projects/working-with-projects.html)
`K8s` provides the concept of a namespace, which allows to define isolation for the `K8s` resources. To isolate applications, `OpenShift` requires that `K8s` resources are not created in the default namespace but instead are created in a user-defined namespace that provides the required isolation. (Project and namespace are synonymous, and `OpenShift` will respond to either `get projects` or `get namespaces`.)
>`$` oc new-project [project-name]<br>
>`$` oc new-project [project-name] --description='Description of project' --display-name='Display name'

To display the current project.
>`$` oc project

To switch between projects.
>`$` oc project [next-project-name]

To create the resources in the namespace.
>`$` oc apply -f [file-name].yaml -n [project-name]

To view the list of projects (namespaces) that the user is authorized to access; however, the `oc get ns` command is accessible only as an admin.
>`$` oc get projects<br>
>`$` oc get [namespaces | ns]

To display the services in the project.
>`$` oc get [service | svc]

To display details of a service.
>`$` oc describe [service-name]

To retrieve a summary of the most important components of a cluster.
>`$` oc get all

### [Applications](https://docs.openshift.com/container-platform/4.7/applications/application_life_cycle_management/creating-applications-using-cli.html)
#### Notes
1. Deploying an application on `OpenShift Container Platform` often requires creating several related resources within a `Project`. For example, an application may require a BuildConfig, DeploymentConfig, Service, and Route resource to run in an `OpenShift` project.
2. `OpenShift` templates provide a way to simplify the creation of resources that an application requires. The `OpenShift` installer creates several templates by default in the `openshift` namespace.
3. `OpenShift Container Platform` manages persistent storage as a set of pooled, cluster-wide resources. To add a storage resource to the cluster, an administrator creates a `PersistentVolume` object that defines the necessary metadata for the storage resource. The metadata describes how the cluster accesses the storage, as well as other storage attributes such as capacity or throughput.

To create the app, ensure the current project is the appropriate project; otherwise, change to the appropriate project.<br>
`OpenShift` will check the contents of the repository and, for known languages, automatically select the appropriate builder image containing the compiler and other tools to build the image.
>`$` oc new-app [language]~https://github.com/[user]/[repo-name].git

How to run an app.
- Create a project.
- Using an image (bitnami images are rootless), generate a yaml file. The `--dry-run` option display the result of the operation without performing it.
- Look at the generate yaml file.
- Create the app.
- Display the resources.
- Display the status.
>`$` oc new-project app<br>
>`$` oc new-app bitnami/nginx --dry-run=true -o yaml > app.yaml<br>
>`$` cat app.yaml<br>
>`$` oc create -f app.yaml<br>
>`$` oc get all<br>
>`$` oc status<br>




To start a build.
>`$` oc start-build [Build-Config-Name]

#### OpenShift Templates
To list the preinstalled templates.
>`$` oc get templates -n openshift

To display a preinstalled template definition in `YAML` format.
>`$` oc get template [name-of-preinstalled-template] -n openshift -o yaml

To publish a new template to the OpenShift cluster so that other developers can build an application from the template.<br>
By default, the template is created under the current project unless a different project is specified using the `-n` option.
>`$` oc create -f [filename-of-template].yaml<br>
>`$` oc create -f [filename-of-template].yaml -n openshift

Templates define a set of parameters, which are assigned values. `OpenShift` resources defined in the template can get their configuration values by referencing named parameters. Parameters in a template can have default values, but they are optional. Any default value can be replaced when processing the template.<br>
To list available parameters from a template.
>`$` oc describe template [name-of-preinstalled-template] -n openshift<br>
>`$` oc process --parameters [name-of-preinstalled-template] -n openshift

To generate a list of resources for a new application. It returns the list of resources to standard output. The format of the output resource list is `JSON`.
>`$` oc process -f [template-filename]

To output the resource list in `YAML` format, use the `-o yaml` option.
>`$` oc process -o yaml -f [template-filename]

To redirect to a file.
>`$` oc process -o yaml -f [template-filename] > [filename].yaml

To process a template from the current project or the `openshift` project.
>`$` oc process [template-filename]<br>
>`$` oc process [template-filename] -n openshift

#### Persistent Storage
See [Volumes](#volumes).

To list the `PersistentVolume` objects in a cluster.
>`$` oc get pv

To see the `YAML` definition for a given `PersistentVolume`.
>`$` oc get pv [pv-name] -o yaml

To add a `PersistentVolume` object to a cluster.<br>
The file must contain a valid persistent volume definition.
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-openssl
spec:
  capacity:
    storage: 10Mi
  accessModes:
  - ReadWriteOnce
  - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
```
>`$` oc create -f [pv-definition-filename].yaml

Create a `PersistentVolumeClaim (PVC)` object to request a dedicated storage resource from the cluster pool. As soon as the claim is created, `K8s` finds the appropriate `PersistentVolume` and binds it to the claim.
>`$` oc create -f [pvc-definition-filename].yaml

### Routes
#### Notes
1. Routes are OpenShift's native implementation of a Layer 7 `reverse proxy` for HTTP(S) connections into load-balancing cluster `Services`.
2. In `OpenShift`, the *default router service* is **`HAProxy`**.
3. `Services` allow for network access among pods *inside* an `OpenShift` cluster, and `routes` allow for network access to pods from applications *outside* the `OpenShift` cluster.
4. Unlike `services`, which use selectors to link to pod resources containing specific labels, a `route` links directly to the `service` resource name.
5. A `route` connects a client-facing IP address and DNS host names to an internal-facing `service` IP. It uses the `service` resource to find the endpoints; that is, the ports exposed by the service. `OpenShift routes` are implemented by a cluster-wide router service, which runs as a containerized application in the `OpenShift` cluster. `OpenShift` scales and replicates router pods like any other `OpenShift` application.
6. In `OpenShift`, the client-facing DNS host names configured for `routes` needs to point to the client-facing IP addresses of the nodes running the routers. `Router pods`, unlike regular application pods, **bind to their nodes' client-facing IP addresses** instead of to the internal pod SDN.
7. The DNS server that hosts the wildcard domain knows nothing about route host names. It merely resolves any name to the configured IP addresses. Only the `OpenShift` router knows about route host names, treating each one as an HTTP virtual host. The `OpenShift` router blocks invalid wildcard domain host names that do not correspond to any route and returns an HTTP 404 error.

To create a `route`, pass a `service` resource name as the input; the --name option can be used to control the name of the route resource.<br>
By default, `routes` created by the `oc expose` command generates DNS names of the form:<br>
*[route-name][project-name].[default-domain]*<br>
Where:<br>
- *route-name* is the name assigned to the route. If no explicit name is set, `OpenShift` assigns the `route` the same name as the originating resource (e.g., the service name).
- *project-name* is the name of the project containing the resource.
- *default-domain* is configured on the `OpenShift` master and corresponds to the wildcard DNS domain listed as a prerequisite for installing `OpenShift`.
For example, creating a `route` named *routeName* in a `project` named *projectName* from an `OpenShift` cluster where the wildcard domain is *apps.com* results in the FQDN *routeNameprojectName.apps.com*.
>`$` oc expose service [service-resource-name] --name [route-resource-name]

Router pods, containers, and their configuration can be inspected just like any other resource in an `OpenShift` cluster.
>`$` oc get pods --all-namespaces -l app=[label-name]<br>
>`$` oc get pods -n [namespace-name] -l app=[label-name]

Or for the current project.
>`$` oc get pods -l app=[label-name]

To get the routing configuration details. By default, routers are deployed in the `openshift-ingress` project.
>`$` oc describe pod [pod-name-or-id]

To delete the current route.<br>
Deleting a route is optional; a service may have multiple routes, if the routes have different names.
>`$` oc delete route/php-helloworld jct




OpenShift uses persistent volumes to provision storage
If no matching persistent volume is found, the PVC will wait until it becomes available
OpenShift provides storage classes as the default solution
oc explain pv.spec | less
To set a StorageClass as default, use
oc annotate storageclass standard -- overwrite "storageclass.kubernetes.io/is-default-class=true"
In order to create persistent volumes on demand, the storage class needs a provisioner. the following default provisioners are provided:
AWS EBC
Azure File
Azure Disk
Cinder
GCE Persistent Disk
VMware vSphere
If you create a storage class for a volume plug-in that does not have a corresponding provisioner, use a storage class 'provisioner' value of 'kubernetes.io/no-provisioner'


oc exec -it [pod-name-or-id] -c [container-name-or-id] -- sh
oc exec  [pod-name-or-id] -c [container-name-or-id] -- ls -l /


Wait until the application finishes building and deploying by monitoring the progress
with the oc get pods -w command:
[student@workstation ~]$ oc get pods -w
Alternatively, monitor the build and deployment logs with the oc logs -f
bc/php-helloworld and oc logs -f dc/php-helloworld commands,
respectively. Press Ctrl+C to exit the command if necessary.

[student@workstation ~]$ oc logs -f bc/php-helloworld
Cloning "https://github.com/${RHT_OCP4_GITHUB_USER}/DO180-apps" ...
 Commit: f7cd8963ef353d9173c3a21dcccf402f3616840b (Initial commit, including all
 apps previously in course)
...output omitted...
STEP 7: USER 1001
STEP 8: RUN /usr/libexec/s2i/assemble
---> Installing application source...
...output omitted...
Push successful
[student@workstation ~]$ oc logs -f dc/php-helloworld
-> Cgroups memory limit is set, using HTTPD_MAX_REQUEST_WORKERS=136
=> sourcing 20-copy-config.sh ...
...output omitted...
[core:notice] [pid 1] AH00094: Command line: 'httpd -D FOREGROUND'
^C
Your exact output may differ.








## Pod Resource Definition
### Notes
1. `RHOCP` runs containers inside K8s pods and to create a pod from a container image, `OpenShift` needs a pod resource definition, which can be provided either as a `JSON` or `YAML` text file. It can also be generated from defaults by the `oc new-app` command or the `OpenShift` web console.
2. Each `service` is assigned a unique IP address for clients to connect. This IP address comes from another internal `OpenShift` SDN, distinct from the pods' internal network, but visible only to pods.
3. Each pod matching the selector is added to the service resource as an endpoint.
4. Pods are attached to a `K8s namespace`, which `OpenShift` calls a `project`. When a pod starts, `K8s` automatically adds a set of `environment variables` for each service defined on the same namespace.

## Service Resource Definition
### Notes
1. `K8s` provides a virtual network that allows pods from different worker nodes to connect, but it provides no easy way for a pod to discover the IP addresses of other pods.
2. `Services` are essential resources to any `OpenShift` application.
   
   - A service is tied to a set of pods, providing a single IP address for the whole set, and a
load-balancing client request among member pods.

   - The set of pods running behind a service is managed by a DeploymentConfig resource. A DeploymentConfig resource embeds a ReplicationController that manages how many pod copies (replicas) have to be created, and creates new ones if any of them fail.





To display each of the standard `OpenShift` API resources that are common when deployment services such as type pod, service, route, deployment, replicaset, build, build config, imagestream, job, and cronjobs.
$ oc get all


## Troubleshooting Application Deployments
Ignore the differences between K8s deployments and OpenShift deployment configurations when troubleshooting applications; the common failure scenarios and the ways to troubleshoot them are essentially the same.

### Troubleshooting Running and Terminated Pods
A container that is running, even for a very short time, generates logs. These logs are not discarded when the container terminates. The `oc logs` command displays the logs from any
container inside a pod. If the pod contains a single container, it requires the name of the pod.
>`$` oc logs [pod-name]

If the pod contains multiple containers, it requires the -c option.
>`$` oc logs [pod-name] -c [container-name]


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

The latest Kubernetes versions implement many controllers as Operators. Operators are Kubernetes plug-in components that can react to cluster events and control
the state of resources. 

Names of different resource types do not collide. It is perfectly legal to have a route





Each Container has a unique PID namespace running its group of process. Inside the Container, the first process is seen as PID 1. From the host perspective, the Container PID is a regular process ID.







<br>

***
# [CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview)
## Notes
1. It is a minimal preconfigured `OpenShift` version 4 cluster from `Red Hat` that can be installed on a laptop or desktop computer. Its virtual machine is a single node `OpenShift` cluster that is fully featured, and it requires a powerful machine to run.
2. It is intended to be used for *development* and *testing* purposes; it provides a fully functional cloud development environment on the local machine with all the tooling necessary to develop container-based applications.
3. CodeReady Containers runs on `Windows`, `macOS`, or `Linux` and has specific requirements for each. Refer to [Getting Started Guide](https://crc.dev/crc/) for installation instructions.

=========
The `apply` command will either create a resource or update any existing matching resources. There is also a supported create command that will assume the resources described by the YAML document do not yet exist. You can typically use apply wherever you use create. In some cases, such as the special generateName attribute, only create is supported.


By default, secure production Kubernetes platforms such as OpenShift are configured to not allow a container image to run as root.

Remember that all resources are either cluster scoped, meaning that only one resource of that kind can exist within the cluster, or namespace scoped, meaning that the resources are isolated from other similar resources on the cluster. Within OpenShift, you may also see the term project, which predated the concept that Red Hat worked with the community to generalize as namespace. Project and namespace are synonymous, and OpenShift will respond to either get projects or get namespaces. You can think of namespaces as like folders within a filesystem that you use to assign to a group of users who are collaborating on a collection of files. We will talk more about namespaces or projects in “OpenShift Enhancements”.


 In Kubernetes and OpenShift, the livenessProbe is performed by the kubelet rather than by a load balancer. As we can see in Figure 4-3, this probe is executed on every node where we find a pod from the deployment.
Every kubelet (one per worker node) is responsible for performing all of the probes for all containers running on the kubelet’s node. This ensures a highly scalable solution that distributes the probe workload and maintains the state and availability of pods and containers across the entire fleet.



Applications 
When using a basic Kubernetes environment, one of the more tedious steps that needs to be performed by a cloud native application developer is creating their own container images. Typically, this involves finding the proper base image and creating a Dockerfile with all the necessary commands for taking a base image and adding in the developer’s code to create an assembled image that can be deployed by Kubernetes. OpenShift introduced the application construct to greatly simplify the process of creating, deploying, and running container images in Kubernetes environments.

Applications are created using the oc new-app command. This command supports a variety of options that enable container images to be built many ways. For example, with the new-app command, application images can be built from local or remote Git repositories, or the application image can be pulled from a Docker Hub or private image registry. In addition, the new-app command supports the creation of application images by inspecting the root directory of the repository to determine the proper way to create the application image. For example, the OpenShift new-app command will look for a JenkinsFile in the root directory of your repository, and if it finds this file, it will use it to create the application image. Furthermore, if the new-app command does not find a JenkinsFile, it will attempt to detect the programming language that your application is built in by looking at the files in your repository. If it is able to determine the programming language that was used, the new-app command will locate an acceptable base image for the programming language you are using and will use this to build your application image.

The following example illustrates using the the oc new-app command to create a new application image from an OpenShift example ruby hello world application:

$ oc new-app https://github.com/openshift/ruby-hello-world.git
This command will create the application as part of whichever OpenShift project was most recently selected to be the current context for the user. For more information on the application image creation options supported by the new-app command, see the OpenShift application creation documentation.



