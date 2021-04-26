
kubectl
=======



Status of different K8S components
----------------------------------
To list all possible object types.
>`\>` kubectl get




**Services**<br>
When a service is created, it gets a static IP, which never changes during the lifetime of the service. Hence, clients should connect to the service through its static IP address and not to pods directly (pods are ephemeral). The service ensures one of the pods receives the connection, regardless of the pod's current IP address.
>`\>` kubectl get services

**Replicaset**<br>
>`\>` kubectl get replicaset


**Events**<br>
To display all events created in the current K8S namespace. If an issue occurs while creating the Deployment, a set of errors or warnings will be displayed.
>`\>` kubectl get events

Debugging Pods
--------------
**To find the ENTRYPOINT and CMD of a container**<br>
If the container is crashing continuously (e.g., CrashLoopBackOff), then inspect the container while running in K8S. To do so, change the container ENTRYPOINT or K8S *command* under *containers*. In Linux, set *command* to *tail -f /dev/null* or *sleep infinity*.
>`\>` docker pull [image]<br>
>`\>` docker inspect [image-id]

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





