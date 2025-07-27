# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-07-13T16:44:29+03:00

This is the seventh blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

## Updating

On all three Rocky Linux 9 boxes `r0`, `r1`, and `r2`:

```sh
dnf update -y
reboot
```

On the FreeBSD hosts, upgrading from FreeBSD 14.2 to 14.3-RELEASE, running this on all three hosts `f0`, `f1` and `f2`:

```sh
paul@f0:~ % doas freebsd-update fetch
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % doas freebsd-update -r 14.3-RELEASE upgrade
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas pkg update
paul@f0:~ % doas pkg upgrade
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % uname -a
FreeBSD f0.lan.buetow.org 14.3-RELEASE FreeBSD 14.3-RELEASE
        releng/14.3-n271432-8c9ce319fef7 GENERIC amd64
```

## Installing k3s

### Generating `K3S_TOKEN` and starting first k3s node

Generating the k3s token on my Fedora Laptop with `pwgen -n 32` and selected one. And then on all 3 `r` hosts (replace SECRET_TOKEN with the actual secret!! before running the following command) run:

```sh
[root@r0 ~]# echo -n SECRET_TOKEN > ~/.k3s_token
```

The following steps are also documented on the k3s website:

=> https://docs.k3s.io/datastore/ha-embedded

So on `r0` we run:

```sh
[root@r0 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --cluster-init --tls-san=r0.wg0.wan.buetow.org
[INFO]  Finding release for channel stable
[INFO]  Using v1.32.6+k3s1 as release
.
.
.
[INFO]  systemd: Starting k3s
```

### Adding the remaining nodes to the cluster

And we run on the other two nodes `r1` and `r2`:

```sh
[root@r1 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --tls-san=r1.wg0.wan.buetow.org

[root@r2 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --tls-san=r2.wg0.wan.buetow.org
.
.
.

```

Once done, we've got a 3 node Kubernetes cluster control plane:

```sh
[root@r0 ~]# kubectl get nodes
NAME                STATUS   ROLES                       AGE     VERSION
r0.lan.buetow.org   Ready    control-plane,etcd,master   4m44s   v1.32.6+k3s1
r1.lan.buetow.org   Ready    control-plane,etcd,master   3m13s   v1.32.6+k3s1
r2.lan.buetow.org   Ready    control-plane,etcd,master   30s     v1.32.6+k3s1

[root@r0 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-5688667fd4-fs2jj                  1/1     Running     0          5m27s
kube-system   helm-install-traefik-crd-f9hgd            0/1     Completed   0          5m27s
kube-system   helm-install-traefik-zqqqk                0/1     Completed   2          5m27s
kube-system   local-path-provisioner-774c6665dc-jqlnc   1/1     Running     0          5m27s
kube-system   metrics-server-6f4c6675d5-5xpmp           1/1     Running     0          5m27s
kube-system   svclb-traefik-411cec5b-cdp2l              2/2     Running     0          78s
kube-system   svclb-traefik-411cec5b-f625r              2/2     Running     0          4m58s
kube-system   svclb-traefik-411cec5b-twrd7              2/2     Running     0          4m2s
kube-system   traefik-c98fdf6fb-lt6fx                   1/1     Running     0          4m58s
```

In order to connect with `kubect` from my Fedora Laptop, I had to copy `/etc/rancher/k3s/k3s.yaml` from `r0` to `~/.kube/config` and then replace the value of the server field with `r0.lan.buetow.org`. kubectl can now manage the cluster. Note this step has to be repeated when we want to connect to another node of the cluster (e.g. when `r0` is down).

### Test deployment to Kubernetes

Let's create a test namespace:

```sh
> ~ kubectl create namespace test
namespace/test created

> ~ kubectl get namespaces
NAME              STATUS   AGE
default           Active   6h11m
kube-node-lease   Active   6h11m
kube-public       Active   6h11m
kube-system       Active   6h11m
test              Active   5s

> ~ kubectl config set-context --current --namespace=test
Context "default" modified.
```

And let's also create an apache test pod:

```sh
> ~ cat <<END > apache-deployment.yaml
# Apache HTTP Server Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:latest
        ports:
        # Container port where Apache listens
        - containerPort: 80
END

> ~ kubectl apply -f apache-deployment.yaml
deployment.apps/apache-deployment created

> ~ kubectl get all
NAME                                     READY   STATUS    RESTARTS   AGE
pod/apache-deployment-5fd955856f-4pjmf   1/1     Running   0          7s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/apache-deployment   1/1     1            1           7s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/apache-deployment-5fd955856f   1         1         1       7s
```

Let's also create a service: 

```sh
> ~ cat <<END > apache-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: apache
  name: apache-service
spec:
  ports:
    - name: web
      port: 80
      protocol: TCP
      # Expose port 80 on the service
      targetPort: 80
  selector:
  # Link this service to pods with the label app=apache
    app: apache
END

> ~ kubectl apply -f apache-service.yaml
service/apache-service created

> ~ kubectl get service
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
apache-service   ClusterIP   10.43.249.165   <none>        80/TCP    4s
```

And also an ingress:

> Note: I've modified the hosts listed in this example after I've published this blog post. This is to ensure that there aren't any bots scarping it.

```sh
> ~ cat <<END > apache-ingress.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: apache-ingress
  namespace: test
  annotations:
    spec.ingressClassName: traefik
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
    - host: f3s.foo.zone
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
    - host: standby.f3s.foo.zone
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
    - host: www.f3s.foo.zone
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
END

> ~ kubectl apply -f apache-ingress.yaml
ingress.networking.k8s.io/apache-ingress created

> ~ kubectl describe ingress
Name:             apache-ingress
Labels:           <none>
Namespace:        test
Address:          192.168.1.120,192.168.1.121,192.168.1.122
Ingress Class:    traefik
Default backend:  <default>
Rules:
  Host                    Path  Backends
  ----                    ----  --------
  f3s.foo.zone
                          /   apache-service:80 (10.42.1.11:80)
  standby.f3s.foo.zone
                          /   apache-service:80 (10.42.1.11:80)
  www.f3s.foo.zone
                          /   apache-service:80 (10.42.1.11:80)
Annotations:              spec.ingressClassName: traefik
                          traefik.ingress.kubernetes.io/router.entrypoints: web
Events:                   <none>
```

Notes: 

* I've modified the ingress hosts after I'd published this blog post. This is to ensure that there aren't any bots scarping it.
* In the ingress we use plain http (web) for the traefik rule, as all the "production" traefic will routed through a WireGuard tunnel anyway as we will see later.

So let's test the Apache webserver through the ingress rule:

```sh
> ~ curl -H "Host: www.f3s.foo.zone" http://r0.lan.buetow.org:80
<html><body><h1>It works!</h1></body></html>
```

## Test deployment with persistent volume claim

So let's modify the Apache example to serve the `htdocs` directory from the NFS share we created in the previous blog post. We are using the following manifests. The majority of the manifests are the same as before, except for the persistent volume claim and the volume mount in the Apache deployment.

```sh
> ~ cat <<END > apache-deployment.yaml
# Apache HTTP Server Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:latest
        ports:
        # Container port where Apache listens
        - containerPort: 80
        volumeMounts:
        - name: apache-htdocs
          mountPath: /usr/local/apache2/htdocs/
      volumes:
      - name: apache-htdocs
        persistentVolumeClaim:
          claimName: example-apache-pvc
END

> ~ cat <<END > apache-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: apache-ingress
  namespace: test
  annotations:
    spec.ingressClassName: traefik
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
    - host: f3s.buetow.org
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
    - host: standby.f3s.buetow.org
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
    - host: www.f3s.buetow.org
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: apache-service
                port:
                  number: 80
END

> ~ cat <<END > apache-persistent-volume.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-apache-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/nfs/k3svolumes/example-apache-volume-claim
    type: Directory
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-apache-pvc
  namespace: test
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
END

> ~ cat <<END > apache-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: apache
  name: apache-service
  namespace: test
spec:
  ports:
    - name: web
      port: 80
      protocol: TCP
      # Expose port 80 on the service
      targetPort: 80
  selector:
  # Link this service to pods with the label app=apache
    app: apache
END
```

And let's apply the manifests:

```sh
> ~ kubectl apply -f apache-persistent-volume.yaml
> ~ kubectl apply -f apache-service.yaml
> ~ kubectl apply -f apache-deployment.yaml
> ~ kubectl apply -f apache-ingress.yaml
```

So looking at the deployment, it failed now, as the directory doesn't exist yet on the NFS share:

```sh
> ~ kubectl get pods
NAME                                 READY   STATUS              RESTARTS   AGE
apache-deployment-5b96bd6b6b-fv2jx   0/1     ContainerCreating   0          9m15s

> ~ kubectl describe pod apache-deployment-5b96bd6b6b-fv2jx | tail -n 5
Events:
  Type     Reason       Age                   From               Message
  ----     ------       ----                  ----               -------
  Normal   Scheduled    9m34s                 default-scheduler  Successfully
    assigned test/apache-deployment-5b96bd6b6b-fv2jx to r2.lan.buetow.org
  Warning  FailedMount  80s (x12 over 9m34s)  kubelet            MountVolume.SetUp
    failed for volume "example-apache-pv" : hostPath type check failed:
    /data/nfs/k3svolumes/example-apache is not a directory
```

This is on purpose! We need to create the directory on the NFS share first, so let's do that (e.g. on `r0`):

```sh
[root@r0 ~]# mkdir /data/nfs/k3svolumes/example-apache-volume-claim/

[root@r0 ~ ] cat <<END > /data/nfs/k3svolumes/example-apache-volume-claim/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Hello, it works</title>
</head>
<body>
  <h1>Hello, it works!</h1>
  <p>This site is served via a PVC!</p>
</body>
</html>
END
```

The `index.html` file was also created to serve content along the way. After deleting the pod, it recreates itself, and the volume mounts correctly:

```sh
> ~ kubectl delete pod apache-deployment-5b96bd6b6b-fv2jx

> ~ curl -H "Host: www.f3s.buetow.org" http://r0.lan.buetow.org:80
<!DOCTYPE html>
<html>
<head>
  <title>Hello, it works</title>
</head>
<body>
  <h1>Hello, it works!</h1>
  <p>This site is served via a PVC!</p>
</body>
</html>
```

## Make it accessible from the public internet

Next, this should be made accessible through the public internet via the `www.f3s.foo.zone` hosts. As a reminder, refer back to part 1 of this series and review the section titled "OpenBSD/relayd to the rescue for external connectivity":

=> ./2024-11-17-f3s-kubernetes-with-freebsd-part-1.gmi f3s: Kubernetes with FreeBSD - Part 1: Setting the stage

> All apps should be reachable through the internet (e.g., from my phone or computer when travelling). For external connectivity and TLS management, I've got two OpenBSD VMs (one hosted by OpenBSD Amsterdam and another hosted by Hetzner) handling public-facing services like DNS, relaying traffic, and automating Let's Encrypt certificates.

> All of this (every Linux VM to every OpenBSD box) will be connected via WireGuard tunnels, keeping everything private and secure. There will be 6 WireGuard tunnels (3 k3s nodes times two OpenBSD VMs).

> So, when I want to access a service running in k3s, I will hit an external DNS endpoint (with the authoritative DNS servers being the OpenBSD boxes). The DNS will resolve to the master OpenBSD VM (see my KISS highly-available with OpenBSD blog post), and from there, the relayd process (with a Let's Encrypt certificate—see my Let's Encrypt with OpenBSD and Rex blog post) will accept the TCP connection and forward it through the WireGuard tunnel to a reachable node port of one of the k3s nodes, thus serving the traffic.

```sh
> ~ curl https://f3s.foo.zone
<html><body><h1>It works!</h1></body></html>

> ~ curl https://www.f3s.foo.zone
<html><body><h1>It works!</h1></body></html>

> ~ curl https://standby.f3s.foo.zone
<html><body><h1>It works!</h1></body></html>
```

## Failure test

Shutting down `f0` and let NFS failing over for the Apache content.


Todo: include k9s screenshot

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site


Note, that I've modified the hosts after I'd published this blog post. This is to ensure that there aren't any bots scarping it.
