# f3s: Kubernetes with FreeBSD - Part 7: k3s and first pod deployments

> Published at 2025-10-02T11:27:19+03:00, last updated Tue 30 Dec 10:11:58 EET 2025

This is the seventh blog post about the f3s series for my self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution I use on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, I am finally going to install k3s (the Kubernetes distribution I use) to the whole setup and deploy the first workloads (helm charts, and a private registry) to it.

=> https://k3s.io

## Important Note: GitOps Migration

**Note:** After publishing this blog post, the f3s cluster was migrated from imperative Helm deployments to declarative GitOps using ArgoCD. The Kubernetes manifests and Helm charts in the repository have been reorganized for ArgoCD-based continuous deployment.

**To view the exact manifests and charts as they existed when this blog post was written** (before the ArgoCD migration), check out the pre-ArgoCD revision:

```sh
$ git clone https://codeberg.org/snonux/conf.git
$ cd conf
$ git checkout 15a86f3  # Last commit before ArgoCD migration
$ cd f3s/
```

**Current master branch** contains the ArgoCD-managed versions with:
- Application manifests organized under `argocd-apps/{monitoring,services,infra,test}/`
- Additional resources under `*/manifests/` directories (e.g., `prometheus/manifests/`)
- Justfiles updated to trigger ArgoCD syncs instead of direct Helm commands

The deployment concepts and architecture remain the same—only the deployment method changed from imperative (`helm install/upgrade`) to declarative (GitOps with ArgoCD).

## Updating

Before proceeding, I bring all systems involved up-to-date. On all three Rocky Linux 9 boxes `r0`, `r1`, and `r2`:

```sh
dnf update -y
reboot
```

On the FreeBSD hosts, I upgraded from FreeBSD 14.2 to 14.3-RELEASE, running this on all three hosts `f0`, `f1` and `f2`:

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

### Generating `K3S_TOKEN` and starting the first k3s node

I generated the k3s token on my Fedora laptop with `pwgen -n 32` and selected one of the results. Then, on all three `r` hosts, I ran the following (replace SECRET_TOKEN with the actual secret):

```sh
[root@r0 ~]# echo -n SECRET_TOKEN > ~/.k3s_token
```

The following steps are also documented on the k3s website:

=> https://docs.k3s.io/datastore/ha-embedded

To bootstrap k3s on the first node, I ran this on `r0`:

```sh
[root@r0 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --cluster-init \
        --node-ip=192.168.2.120 \
        --advertise-address=192.168.2.120 \
        --tls-san=r0.wg0.wan.buetow.org
[INFO]  Finding release for channel stable
[INFO]  Using v1.32.6+k3s1 as release
.
.
.
[INFO]  systemd: Starting k3s
```

Note: The `--node-ip` and `--advertise-address` flags are important to ensure that the embedded etcd cluster communicates over the WireGuard interface (192.168.2.x) rather than the LAN interface (192.168.1.x). This ensures that all control plane traffic is encrypted via WireGuard.

### Adding the remaining nodes to the cluster

Then I ran on the other two nodes `r1` and `r2`:

```sh
[root@r1 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --node-ip=192.168.2.121 \
        --advertise-address=192.168.2.121 \
        --tls-san=r1.wg0.wan.buetow.org

[root@r2 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --node-ip=192.168.2.122 \
        --advertise-address=192.168.2.122 \
        --tls-san=r2.wg0.wan.buetow.org
.
.
.

```

Once done, I had a three-node Kubernetes cluster control plane:

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

In order to connect with `kubectl` from my Fedora laptop, I had to copy `/etc/rancher/k3s/k3s.yaml` from `r0` to `~/.kube/config` and then replace the value of the server field with `r0.lan.buetow.org`. kubectl can now manage the cluster. Note that this step has to be repeated when I want to connect to another node of the cluster (e.g. when `r0` is down).

## Test deployments

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

And let's also create an Apache test pod:

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

Now let's create an ingress:

> Note: I've modified the hosts listed in this example after I published this blog post to ensure that there aren't any bots scraping it.

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
Address:          192.168.2.120,192.168.2.121,192.168.2.122
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

* In the ingress, I use plain HTTP (web) for the Traefik rule, as all the "production" traffic will be routed through a WireGuard tunnel anyway, as I will show later.

So I tested the Apache web server through the ingress rule:

```sh
> ~ curl -H "Host: www.f3s.foo.zone" http://r0.lan.buetow.org:80
<html><body><h1>It works!</h1></body></html>
```

### Test deployment with persistent volume claim

Next, I modified the Apache example to serve the `htdocs` directory from the NFS share I created in the previous blog post. I used the following manifests. Most of them are the same as before, except for the persistent volume claim and the volume mount in the Apache deployment.

```sh
> ~ cat <<END > apache-deployment.yaml
# Apache HTTP Server Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: test
spec:
  replicas: 2
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
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 10
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

I applied the manifests:

```sh
> ~ kubectl apply -f apache-persistent-volume.yaml
> ~ kubectl apply -f apache-service.yaml
> ~ kubectl apply -f apache-deployment.yaml
> ~ kubectl apply -f apache-ingress.yaml
```

Looking at the deployment, I could see it failed because the directory didn't exist yet on the NFS share (note that I also increased the replica count to 2 so if one node goes down there's already a replica running on another node for faster failover):

```sh
> ~ kubectl get pods
NAME                                 READY   STATUS              RESTARTS   AGE
apache-deployment-5b96bd6b6b-fv2jx   0/1     ContainerCreating   0          9m15s
apache-deployment-5b96bd6b6b-ax2ji   0/1     ContainerCreating   0          9m15s

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

That's intentional—I needed to create the directory on the NFS share first, so I did that (e.g. on `r0`):

```sh
[root@r0 ~]# mkdir /data/nfs/k3svolumes/example-apache-volume-claim/

[root@r0 ~]# cat <<END > /data/nfs/k3svolumes/example-apache-volume-claim/index.html
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

The `index.html` file gives us some actual content to serve. After deleting the pod, it recreates itself and the volume mounts correctly:

```sh
> ~ kubectl delete pod apache-deployment-5b96bd6b6b-fv2jx

> ~ curl -H "Host: www.f3s.foo.zone" http://r0.lan.buetow.org:80
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

### Scaling Traefik for faster failover

Traefik (used for ingress on k3s) ships with a single replica by default, but for faster failover I bumped it to two replicas so each worker node runs one pod. That way, if a node disappears, the service stays up while Kubernetes schedules a replacement. Here's the command I used:

```sh
> ~ kubectl -n kube-system scale deployment traefik --replicas=2
```

And the result:

```sh
> ~ kubectl -n kube-system get pods -l app.kubernetes.io/name=traefik
kube-system   traefik-c98fdf6fb-97kqk   1/1   Running   19 (53d ago)   64d
kube-system   traefik-c98fdf6fb-9npg2   1/1   Running   11 (53d ago)   61d
```

## Make it accessible from the public internet

Next, I made this accessible through the public internet via the `www.f3s.foo.zone` hosts. As a reminder from part 1 of this series, I reviewed the section titled "OpenBSD/relayd to the rescue for external connectivity":

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

This is how it works in `relayd.conf` on OpenBSD:

### OpenBSD relayd configuration

The OpenBSD edge relays keep the Kubernetes-facing addresses for the f3s ingress endpoints in a shared backend table so TLS traffic for every `f3s` hostname lands on the same pool of k3s nodes (pointing to the WireGuard IP addresses of those nodes - remember, they are running locally in my LAN, wheras the OpenBSD edge relays operate in the public internet):

```
table <f3s> {
  192.168.2.120
  192.168.2.121
  192.168.2.122
}
```

Inside the `http protocol "https"` block each public hostname gets its Let's Encrypt certificate. The protocol configures TLS keypairs for all f3s services and other public endpoints. For f3s hosts specifically, there are no explicit `forward to` rules in the protocol—they use the relay-level failover mechanism described later. Non-f3s hosts get explicit localhost routing to prevent them from trying the f3s backends:

```
http protocol "https" {
    # TLS certificates for all f3s services
    tls keypair f3s.foo.zone
    tls keypair www.f3s.foo.zone
    tls keypair standby.f3s.foo.zone
    tls keypair anki.f3s.foo.zone
    tls keypair www.anki.f3s.foo.zone
    tls keypair standby.anki.f3s.foo.zone
    tls keypair bag.f3s.foo.zone
    tls keypair www.bag.f3s.foo.zone
    tls keypair standby.bag.f3s.foo.zone
    tls keypair flux.f3s.foo.zone
    tls keypair www.flux.f3s.foo.zone
    tls keypair standby.flux.f3s.foo.zone
    tls keypair audiobookshelf.f3s.foo.zone
    tls keypair www.audiobookshelf.f3s.foo.zone
    tls keypair standby.audiobookshelf.f3s.foo.zone
    tls keypair gpodder.f3s.foo.zone
    tls keypair www.gpodder.f3s.foo.zone
    tls keypair standby.gpodder.f3s.foo.zone
    tls keypair radicale.f3s.foo.zone
    tls keypair www.radicale.f3s.foo.zone
    tls keypair standby.radicale.f3s.foo.zone
    tls keypair vault.f3s.foo.zone
    tls keypair www.vault.f3s.foo.zone
    tls keypair standby.vault.f3s.foo.zone
    tls keypair syncthing.f3s.foo.zone
    tls keypair www.syncthing.f3s.foo.zone
    tls keypair standby.syncthing.f3s.foo.zone
    tls keypair uprecords.f3s.foo.zone
    tls keypair www.uprecords.f3s.foo.zone
    tls keypair standby.uprecords.f3s.foo.zone

    # Explicitly route non-f3s hosts to localhost
    match request header "Host" value "foo.zone" forward to <localhost>
    match request header "Host" value "www.foo.zone" forward to <localhost>
    match request header "Host" value "dtail.dev" forward to <localhost>
    # ... other non-f3s hosts ...

    # NOTE: f3s hosts have NO match rules here!
    # They use relay-level failover (f3s -> localhost backup)
    # See the relay configuration below for automatic failover details
}
```

Both IPv4 and IPv6 listeners reuse the same protocol definition, making the relay transparent for dual-stack clients while still health checking every k3s backend before forwarding traffic over WireGuard:

```
relay "https4" {
    listen on 46.23.94.99 port 443 tls
    protocol "https"
    # Primary: f3s cluster (with health checks) - Falls back to localhost when all hosts down
    forward to <f3s> port 80 check tcp
    forward to <localhost> port 8080
}

relay "https6" {
    listen on 2a03:6000:6f67:624::99 port 443 tls
    protocol "https"
    # Primary: f3s cluster (with health checks) - Falls back to localhost when all hosts down
    forward to <f3s> port 80 check tcp
    forward to <localhost> port 8080
}
```

In practice, that means relayd terminates TLS with the correct certificate, keeps the three WireGuard-connected backends in rotation, and ships each request to whichever bhyve VM answers first.

### Automatic failover when f3s cluster is down

> Update: This section was added at Tue 30 Dec 10:11:44 EET 2025

One important aspect of this setup is graceful degradation: when all three f3s nodes are unreachable (e.g., during maintenance or a power outage in my LAN), users should see a friendly status page instead of an error message.

OpenBSD's relayd supports automatic failover through its health check mechanism. According to the relayd.conf manual:

> This directive can be specified multiple times - subsequent entries will be used as the backup table if all hosts in the previous table are down.

The key is the order of `forward to` statements in the relay configuration. By placing the f3s table first with `check tcp` health checks, followed by localhost as a backup, relayd automatically routes traffic based on backend availability:

When f3s cluster is UP:

* Health checks on port 80 succeed for f3s nodes
* All f3s traffic routes to the Kubernetes cluster
* Localhost backup remains idle

When f3s cluster is DOWN:

* All health checks fail (nodes unreachable)
* The `<f3s>` table becomes unavailable
* Traffic automatically falls back to `<localhost>` on port 8080
* OpenBSD's httpd serves a static fallback page

```
# NEW configuration - supports automatic failover
http protocol "https" {
    # Explicitly route non-f3s hosts to localhost
    match request header "Host" value "foo.zone" forward to <localhost>
    match request header "Host" value "dtail.dev" forward to <localhost>
    # ... other non-f3s hosts ...

    # f3s hosts have NO protocol rules - they use relay-level failover
    # (no match rules for f3s.foo.zone, anki.f3s.foo.zone, etc.)
}

relay "https4" {
    # f3s FIRST (with health checks), localhost as BACKUP
    forward to <f3s> port 80 check tcp
    forward to <localhost> port 8080
}
```

This way, f3s traffic uses the relay's default behavior: try the first table, fall back to the second when health checks fail.

### OpenBSD httpd fallback configuration

The localhost httpd service on port 8080 serves the fallback content from `/var/www/htdocs/f3s_fallback/`. This directory contains a simple HTML page explaining the situation.

The key configuration detail is using `request rewrite` to ensure the fallback page is served for ALL paths, not just the root. Without this, accessing paths like `/login?redirect=/files/` would return 404 instead of the fallback page:

```
# OpenBSD httpd.conf
# Fallback for f3s hosts - serve fallback page for ALL paths
server "f3s.foo.zone" {
  listen on * port 8080
  log style forwarded
  location * {
    # Rewrite all requests to /index.html to show fallback page regardless of path
    request rewrite "/index.html"
    root "/htdocs/f3s_fallback"
  }
}

server "anki.f3s.foo.zone" {
  listen on * port 8080
  log style forwarded
  location * {
    request rewrite "/index.html"
    root "/htdocs/f3s_fallback"
  }
}

# ... similar blocks for all f3s hostnames ...
```

The `request rewrite "/index.html"` directive ensures that whether someone accesses `/`, `/login`, `/api/status`, or any other path, they all receive the same fallback page. This prevents confusing 404 errors when users have bookmarked specific URLs or follow deep links while the cluster is down.

The fallback page itself is straightforward:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Server turned off</title>
    <style>
        body {
            font-family: sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Server turned off</h1>
        <p>The servers are all currently turned off.</p>
        <p>Please try again later.</p>
        <p>Or email <a href="mailto:paul@nospam.buetow.org">paul@nospam.buetow.org</a>
           - so I can turn them back on for you!</p>
    </div>
</body>
</html>
```

This approach provides several benefits:

* Automatic detection: Health checks run continuously; no manual intervention needed
* Instant fallback: When all f3s nodes go down, the next request automatically routes to localhost
* Transparent recovery: When f3s comes back online, health checks pass and traffic resumes automatically
* User experience: Visitors see a helpful message instead of connection errors
* No DNS changes: The same hostnames work whether f3s is up or down

This fallback mechanism has proven invaluable during maintenance windows and unexpected outages, ensuring that users always get a response even when the home lab is offline.

## Deploying the private Docker image registry

As not all Docker images I want to deploy are available on public Docker registries and as I also build some of them by myself, there is the need of a private registry.

All manifests for the f3s stack live in my configuration repository:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s codeberg.org/snonux/conf/f3s

Within that repo, the `f3s/registry/` directory contains the Helm chart, a `Justfile`, and a detailed `README`. Here's the condensed walkthrough I used to roll out the registry with Helm.

### Prepare the NFS-backed storage

Create the directory that will hold the registry blobs on the NFS share (I ran this on `r0`, but any node that exports `/data/nfs/k3svolumes` works):

```sh
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes/registry
```

### Install (or upgrade) the chart

Clone the repo (or pull the latest changes) on a workstation that has `helm` configured for the cluster, then deploy the chart. The Justfile wraps the commands, but the raw Helm invocation looks like this:

```sh
$ git clone https://codeberg.org/snonux/conf/f3s.git
$ cd conf/f3s/examples/conf/f3s/registry
$ helm upgrade --install registry ./helm-chart --namespace infra --create-namespace
```

Helm creates the `infra` namespace if it does not exist, provisions a `PersistentVolume`/`PersistentVolumeClaim` pair that points at `/data/nfs/k3svolumes/registry`, and spins up a single registry pod exposed via the `docker-registry-service` NodePort (`30001`). Verify everything is up before continuing:

```sh
$ kubectl get pods --namespace infra
NAME                               READY   STATUS    RESTARTS      AGE
docker-registry-6bc9bb46bb-6grkr   1/1     Running   6 (53d ago)   54d

$ kubectl get svc docker-registry-service -n infra
NAME                      TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
docker-registry-service   NodePort   10.43.141.56   <none>        5000:30001/TCP   54d
```

### Allow nodes and workstations to trust the registry

The registry listens on plain HTTP, so both Docker daemons on workstations and the k3s nodes need to treat it as an insecure registry. That's fine for my personal needs, as:

* I don't store any secrets in the images
* I access the registry this way only via my LAN
* I may will change it later on...

On my Fedora workstation where I build images:

```sh
$ cat <<"EOF" | sudo tee /etc/docker/daemon.json >/dev/null
{
  "insecure-registries": [
    "r0.lan.buetow.org:30001",
    "r1.lan.buetow.org:30001",
    "r2.lan.buetow.org:30001"
  ]
}
EOF
$ sudo systemctl restart docker
```

On each k3s node, make `registry.lan.buetow.org` resolve locally and point k3s at the NodePort:

```sh
$ for node in r0 r1 r2; do
>   ssh root@$node "echo '127.0.0.1 registry.lan.buetow.org' >> /etc/hosts"
> done

$ for node in r0 r1 r2; do
> ssh root@$node "cat <<'EOF' > /etc/rancher/k3s/registries.yaml
mirrors:
  "registry.lan.buetow.org:30001":
    endpoint:
      - "http://localhost:30001"
EOF
systemctl restart k3s"
> done
```

Thanks to the relayd configuration earlier in the post, the external hostnames (`f3s.foo.zone`, etc.) can already reach NodePort `30001`, so publishing the registry later to the outside world is just a matter of wiring the DNS the same way as the ingress hosts. But by default, that's not enabled for now due to security reasons.

### Pushing and pulling images

Tag any locally built image with one of the node IPs on port `30001`, then push it. I usually target whichever node is closest to me, but any of the three will do:

```sh
$ docker tag my-app:latest r0.lan.buetow.org:30001/my-app:latest
$ docker push r0.lan.buetow.org:30001/my-app:latest
```

Inside the cluster (or from other nodes), reference the image via the service name that Helm created:

```
image: docker-registry-service:5000/my-app:latest
```

You can test the pull path straight away:

```sh
$ kubectl run registry-test \
>   --image=docker-registry-service:5000/my-app:latest \
>   --restart=Never -n test --command -- sleep 300
```

If the pod pulls successfully, the private registry is ready for use by the rest of the workloads. Note, that the commands above actually don't work, they are only for illustration purpose mentioned here.

## Example: Anki Sync Server from the private registry

One of the first workloads I migrated onto the k3s cluster after standing up the registry was my Anki sync server. The configuration repo ships everything in `examples/conf/f3s/anki-sync-server/`: a Docker build context plus a Helm chart that references the freshly built image.

### Build and push the image

The Dockerfile lives under `docker-image/` and takes the Anki release to compile as an `ANKI_VERSION` build argument. The accompanying `Justfile` wraps the steps, but the raw commands look like this:

```sh
$ cd conf/f3s/examples/conf/f3s/anki-sync-server/docker-image
$ docker build -t anki-sync-server:25.07.5b --build-arg ANKI_VERSION=25.07.5 .
$ docker tag anki-sync-server:25.07.5b \
    r0.lan.buetow.org:30001/anki-sync-server:25.07.5b
$ docker push r0.lan.buetow.org:30001/anki-sync-server:25.07.5b
```

Because every k3s node treats `registry.lan.buetow.org:30001` as an insecure mirror (see above), the push succeeds regardless of which node answers. If you prefer the shortcut, `just f3s` in that directory performs the same build/tag/push sequence.

### Create the Anki secret and storage on the cluster

The Helm chart expects the `services` namespace, a pre-created NFS directory, and a Kubernetes secret that holds the credentials the upstream container understands:

```sh
$ ssh root@r0 "mkdir -p /data/nfs/k3svolumes/anki-sync-server/anki_data"
$ kubectl create namespace services
$ kubectl create secret generic anki-sync-server-secret \
    --from-literal=SYNC_USER1='paul:SECRETPASSWORD' \
    -n services
```

If the `services` namespace already exists, you can skip that line or let Kubernetes tell you the namespace is unchanged.

### Deploy the chart

With the prerequisites in place, install (or upgrade) the chart. It pins the container image to the tag we just pushed and mounts the NFS export via a `PersistentVolume/PersistentVolumeClaim` pair:

```sh
$ cd ../helm-chart
$ helm upgrade --install anki-sync-server . -n services
```

Helm provisions everything referenced in the templates:

```
containers:
- name: anki-sync-server  image: registry.lan.buetow.org:30001/anki-sync-server:25.07.5b
  volumeMounts:
  - name: anki-data
    mountPath: /anki_data
```

Once the release comes up, verify that the pod pulled the freshly pushed image and that the ingress we configured earlier resolves through relayd just like the Apache example.

```sh
$ kubectl get pods -n services
$ kubectl get ingress anki-sync-server-ingress -n services
$ curl https://anki.f3s.foo.zone/health
```

All of this runs solely on first-party images that now live in the private registry, proving the full flow from local bild to WireGuard-exposed service.

## NFSv4 UID mapping for Postgres-backed (and other) apps

NFSv4 only sees numeric user and group IDs, so the `postgres` account created inside the container must exist with the same UID/GID on the Kubernetes worker and on the FreeBSD NFS servers. Otherwise the pod starts with UID 999, the export sees it as an unknown anonymous user, and Postgres fails to initialise its data directory.

To verify things line up end-to-end I run `id` in the container and on the hosts:

```sh
> ~ kubectl exec -n services deploy/miniflux-postgres -- id postgres
uid=999(postgres) gid=999(postgres) groups=999(postgres)

[root@r0 ~]# id postgres
uid=999(postgres) gid=999(postgres) groups=999(postgres)

paul@f0:~ % doas id postgres
uid=999(postgres) gid=99(postgres) groups=999(postgres)
```

The Rocky Linux workers get their matching user with plain `useradd`/`groupadd` (repeat on `r0`, `r1`, and `r2`):

```sh
[root@r0 ~]# groupadd --gid 999 postgres
[root@r0 ~]# useradd --uid 999 --gid 999 \
                --home-dir /var/lib/pgsql \
                --shell /sbin/nologin postgres
```

FreeBSD uses `pw`, so on each NFS server (`f0`, `f1`, `f2`) I created the same account and disabled shell access:

```sh
paul@f0:~ % doas pw groupadd postgres -g 999
paul@f0:~ % doas pw useradd postgres -u 999 -g postgres \
                -d /var/db/postgres -s /usr/sbin/nologin
```

Once the UID/GID exist everywhere, the Miniflux chart in `examples/conf/f3s/miniflux` deploys cleanly. The chart provisions both the application and its bundled Postgres database, mounts the exported directory, and builds the DSN at runtime. The important bits live in `helm-chart/templates/persistent-volumes.yaml` and `deployment.yaml`:

```
# Persistent volume lives on the NFS export
hostPath:
  path: /data/nfs/k3svolumes/miniflux/data
  type: Directory
...
containers:
- name: miniflux-postgres
  image: postgres:17
  volumeMounts:
  - name: miniflux-postgres-data
    mountPath: /var/lib/postgresql/data
```

Follow the `README` beside the chart to create the secrets and the target directory:

```sh
$ cd examples/conf/f3s/miniflux/helm-chart
$ mkdir -p /data/nfs/k3svolumes/miniflux/data
$ kubectl create secret generic miniflux-db-password \
    --from-literal=fluxdb_password='YOUR_PASSWORD' -n services
$ kubectl create secret generic miniflux-admin-password \
    --from-literal=admin_password='YOUR_ADMIN_PASSWORD' -n services
$ helm upgrade --install miniflux . -n services --create-namespace
```

And to verify it's all up:

```
$ kubectl get all --namespace=services | grep mini
pod/miniflux-postgres-556444cb8d-xvv2p   1/1     Running   0             54d
pod/miniflux-server-85d7c64664-stmt9     1/1     Running   0             54d
service/miniflux                   ClusterIP   10.43.47.80     <none>        8080/TCP             54d
service/miniflux-postgres          ClusterIP   10.43.139.50    <none>        5432/TCP             54d
deployment.apps/miniflux-postgres   1/1     1            1           54d
deployment.apps/miniflux-server     1/1     1            1           54d
replicaset.apps/miniflux-postgres-556444cb8d   1         1         1       54d
replicaset.apps/miniflux-server-85d7c64664     1         1         1       54d
```

Or from the repository root I simply run:

### Helm charts currently in service

These are the charts that already live under `examples/conf/f3s` and run on the cluster today (and I'll keep adding more as new services graduate into production):

* `anki-sync-server` — custom-built image served from the private registry, stores decks on `/data/nfs/k3svolumes/anki-sync-server/anki_data`, and authenticates through the `anki-sync-server-secret`.
* `koreade-sync-server` — Sync server for KOReader.
* `audiobookshelf` — media streaming stack with three hostPath mounts (`config`, `audiobooks`, `podcasts`) so the library survives node rebuilds.
* `example-apache` — minimal HTTP service I use for smoke-testing ingress and relayd rules.
* `example-apache-volume-claim` — Apache plus PVC variant that exercises NFS-backed storage for walkthroughs like the one earlier in this post.
* `miniflux` — the Postgres-backed feed reader described above, wired for NFSv4 UID mapping and per-release secrets.
* `opodsync` — podsync deployment with its data directory under `/data/nfs/k3svolumes/opodsync/data`.
* `radicale` — CalDAV/CardDAV (and gpodder) backend with separate `collections` and `auth` volumes.
* `registry` — the plain-HTTP Docker registry exposed on NodePort 30001 and mirrored internally as `registry.lan.buetow.org:30001`.
* `syncthing` — two-volume setup for config and shared data, fronted by the `syncthing.f3s.foo.zone` ingress.
* `wallabag` — read-it-later service with persistent `data` and `images` directories on the NFS export.

I hope you enjoyed this walkthrough. Read the next post of this series:

=> ./2025-12-07-f3s-kubernetes-with-freebsd-part-8.gmi f3s: Kubernetes with FreeBSD - Part 8: Observability

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
