# f3s: Kubernetes with FreeBSD - Part 8: Grafana, Prometheus, Loki, and Alloy

This is the 8th blog post about the f3s series for my self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution I use on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, I set up a complete observability stack for the k3s cluster. Observability is crucial for understanding what's happening inside the cluster—whether it's tracking resource usage, debugging issues, or analysing application behaviour. The stack consists of four main components, all deployed into the `monitoring` namespace:

* **Prometheus** — time-series database for metrics collection and alerting
* **Grafana** — visualisation and dashboarding frontend
* **Loki** — log aggregation system (like Prometheus, but for logs)
* **Alloy** — telemetry collector that ships logs from all pods to Loki

Together, these form the "PLG" stack (Prometheus, Loki, Grafana), which is a popular open-source alternative to commercial observability platforms.

All manifests for the f3s stack live in my configuration repository:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s codeberg.org/snonux/conf/f3s

## Persistent storage recap

All observability components need persistent storage so that metrics and logs survive pod restarts. As covered in Part 6 of this series, the cluster uses NFS-backed persistent volumes:

=> ./2025-07-14-f3s-kubernetes-with-freebsd-part-6.gmi f3s: Kubernetes with FreeBSD - Part 6: Storage

The FreeBSD hosts (`f0`, `f1`, `f2`) serve as NFS servers, exporting ZFS datasets that are replicated across hosts using `zrepl`. The Rocky Linux k3s nodes (`r0`, `r1`, `r2`) mount these exports at `/data/nfs/k3svolumes`. This directory contains subdirectories for each application that needs persistent storage—including Prometheus, Grafana, and Loki.

For example, the observability stack uses these paths on the NFS share:

* `/data/nfs/k3svolumes/prometheus/data` — Prometheus time-series database
* `/data/nfs/k3svolumes/grafana/data` — Grafana configuration, dashboards, and plugins
* `/data/nfs/k3svolumes/loki/data` — Loki log chunks and index

Each path gets a corresponding `PersistentVolume` and `PersistentVolumeClaim` in Kubernetes, allowing pods to mount them as regular volumes. Because the underlying storage is ZFS with replication, we get snapshots and redundancy for free.

## The monitoring namespace

First, I created the monitoring namespace where all observability components will live:

```sh
$ kubectl create namespace monitoring
namespace/monitoring created
```

## Installing Prometheus and Grafana

Prometheus and Grafana are deployed together using the `kube-prometheus-stack` Helm chart from the Prometheus community. This chart bundles Prometheus, Grafana, Alertmanager, and various exporters into a single deployment.

### What each component does

* **Prometheus** — scrapes metrics from all pods and services, stores them in a time-series database, and evaluates alerting rules
* **Grafana** — provides dashboards and visualisation for metrics (and later, logs from Loki)
* **Alertmanager** — handles alerts from Prometheus, deduplicates them, and routes notifications
* **Node Exporter** — runs as a DaemonSet on each node to expose hardware and OS metrics
* **Kube State Metrics** — exposes Kubernetes object metrics (deployments, pods, etc.)

### Prerequisites

Add the Prometheus Helm chart repository:

```sh
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo update
```

Create the directories on the NFS server for persistent storage:

```sh
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes/prometheus/data
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes/grafana/data
```

### Deploying with the Justfile

The configuration repository contains a `Justfile` that automates the deployment. `just` is a handy command runner—think of it as a simpler, more modern alternative to `make`. I use it throughout the f3s repository to wrap repetitive Helm and kubectl commands:

=> https://github.com/casey/just just - A handy way to save and run project-specific commands

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/prometheus codeberg.org/snonux/conf/f3s/prometheus

To install everything:

```sh
$ cd conf/f3s/prometheus
$ just install
kubectl apply -f persistent-volumes.yaml
persistentvolume/prometheus-data-pv created
persistentvolume/grafana-data-pv created
persistentvolumeclaim/grafana-data-pvc created
helm install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring -f persistence-values.yaml
NAME: prometheus
LAST DEPLOYED: ...
NAMESPACE: monitoring
STATUS: deployed
```

The `persistence-values.yaml` configures Prometheus and Grafana to use the NFS-backed persistent volumes I mentioned earlier, ensuring data survives pod restarts. The persistent volume definitions bind to specific paths on the NFS share using `hostPath` volumes—the same pattern used for other services in Part 7:

=> ./2025-10-02-f3s-kubernetes-with-freebsd-part-7.gmi f3s: Kubernetes with FreeBSD - Part 7: k3s and first pod deployments

### Exposing Grafana via ingress

The chart also deploys an ingress for Grafana, making it accessible at `grafana.f3s.foo.zone`. The ingress configuration follows the same pattern as other services in the cluster—Traefik handles the routing internally, while the OpenBSD edge relays terminate TLS and forward traffic through WireGuard.

Once deployed, Grafana is accessible and comes pre-configured with Prometheus as a data source. The default credentials are `admin`/`prom-operator`, which should be changed immediately after first login.

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-dashboard.png Grafana dashboard showing cluster metrics

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-node-exporter.png Node Exporter dashboard with host metrics

## Installing Loki and Alloy

While Prometheus handles metrics, Loki handles logs. It's designed to be cost-effective and easy to operate—it doesn't index the contents of logs, only the metadata (labels), making it very efficient for storage.

Alloy is Grafana's telemetry collector (the successor to Promtail). It runs as a DaemonSet on each node, tails container logs, and ships them to Loki.

### Prerequisites

Create the data directory on the NFS server:

```sh
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes/loki/data
```

### Deploying Loki and Alloy

The Loki configuration also lives in the repository:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/loki codeberg.org/snonux/conf/f3s/loki

To install:

```sh
$ cd conf/f3s/loki
$ just install
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update
kubectl apply -f persistent-volumes.yaml
persistentvolume/loki-data-pv created
persistentvolumeclaim/loki-data-pvc created
helm install loki grafana/loki --namespace monitoring -f values.yaml
NAME: loki
LAST DEPLOYED: ...
NAMESPACE: monitoring
STATUS: deployed
...
helm install alloy grafana/alloy --namespace monitoring -f alloy-values.yaml
NAME: alloy
LAST DEPLOYED: ...
NAMESPACE: monitoring
STATUS: deployed
```

Loki runs in single-binary mode with a single replica (`loki-0`), which is appropriate for a home lab cluster. This means there's only one Loki pod running at any time. If the node hosting Loki fails, Kubernetes will automatically reschedule the pod to another worker node—but there will be a brief downtime (typically under a minute) while this happens. For my home lab use case, this is perfectly acceptable.

For full high-availability, you'd deploy Loki in microservices mode with separate read, write, and backend components, backed by object storage like S3 or MinIO instead of local filesystem storage. That's a more complex setup that I might explore in a future blog post—but for now, the single-binary mode with NFS-backed persistence strikes the right balance between simplicity and durability.

### Configuring Alloy

Alloy is configured via `alloy-values.yaml` to discover all pods in the cluster and forward their logs to Loki:

```
discovery.kubernetes "pods" {
  role = "pod"
}

discovery.relabel "pods" {
  targets = discovery.kubernetes.pods.targets

  rule {
    source_labels = ["__meta_kubernetes_namespace"]
    target_label  = "namespace"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    target_label  = "pod"
  }

  rule {
    source_labels = ["__meta_kubernetes_pod_container_name"]
    target_label  = "container"
  }
}

loki.source.kubernetes "pods" {
  targets    = discovery.relabel.pods.output
  forward_to = [loki.write.default.receiver]
}

loki.write "default" {
  endpoint {
    url = "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"
  }
}
```

This configuration automatically labels each log line with the namespace, pod name, and container name, making it easy to filter logs in Grafana.

### Adding Loki as a Grafana data source

Loki doesn't have its own web UI—you query it through Grafana. To add Loki as a data source in Grafana:

* Navigate to Configuration → Data Sources
* Click "Add data source"
* Select "Loki"
* Set the URL to: `http://loki.monitoring.svc.cluster.local:3100`
* Click "Save & Test"

Once configured, you can explore logs in Grafana's "Explore" view using LogQL queries like:

```
{namespace="services"}
{pod=~"miniflux.*"}
{namespace="kube-system", container="traefik"}
```

=> ./f3s-kubernetes-with-freebsd-part-8/loki-explore.png Exploring logs in Grafana with Loki

=> ./f3s-kubernetes-with-freebsd-part-8/loki-logs-detail.png Detailed log view with parsed fields

## The complete monitoring stack

After deploying everything, here's what's running in the monitoring namespace:

```sh
$ kubectl get pods -n monitoring
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          42d
alloy-g5fgj                                              2/2     Running   0          29m
alloy-nfw8w                                              2/2     Running   0          29m
alloy-tg9vj                                              2/2     Running   0          29m
loki-0                                                   2/2     Running   0          25m
prometheus-grafana-868f9dc7cf-lg2vl                      3/3     Running   0          42d
prometheus-kube-prometheus-operator-8d7bbc48c-p4sf4      1/1     Running   0          42d
prometheus-kube-state-metrics-7c5fb9d798-hh2fx           1/1     Running   0          42d
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          42d
prometheus-prometheus-node-exporter-2nsg9                1/1     Running   0          42d
prometheus-prometheus-node-exporter-mqr25                1/1     Running   0          42d
prometheus-prometheus-node-exporter-wp4ds                1/1     Running   0          42d
```

And the services:

```sh
$ kubectl get svc -n monitoring
NAME                                      TYPE        CLUSTER-IP      PORT(S)
alertmanager-operated                     ClusterIP   None            9093/TCP,9094/TCP
alloy                                     ClusterIP   10.43.74.14     12345/TCP
loki                                      ClusterIP   10.43.64.60     3100/TCP,9095/TCP
loki-headless                             ClusterIP   None            3100/TCP
prometheus-grafana                        ClusterIP   10.43.46.82     80/TCP
prometheus-kube-prometheus-alertmanager   ClusterIP   10.43.208.43    9093/TCP,8080/TCP
prometheus-kube-prometheus-operator       ClusterIP   10.43.246.121   443/TCP
prometheus-kube-prometheus-prometheus     ClusterIP   10.43.152.163   9090/TCP,8080/TCP
prometheus-kube-state-metrics             ClusterIP   10.43.64.26     8080/TCP
prometheus-prometheus-node-exporter       ClusterIP   10.43.127.242   9100/TCP
```

Let me break down what each pod does:

* **alertmanager-...** — handles alerting rules and notifications
* **alloy-*** — three pods (one per node) collecting logs and shipping to Loki
* **loki-0** — the log aggregation backend
* **prometheus-grafana-...** — the Grafana frontend
* **prometheus-kube-prometheus-operator-...** — manages Prometheus configuration via CRDs
* **prometheus-kube-state-metrics-...** — exposes Kubernetes object metrics
* **prometheus-prometheus-...** — the Prometheus server itself
* **prometheus-prometheus-node-exporter-*** — three pods (one per node) exposing host metrics

## Using the observability stack

### Viewing metrics in Grafana

The kube-prometheus-stack comes with many pre-built dashboards. Some useful ones include:

* **Kubernetes / Compute Resources / Cluster** — overview of CPU and memory usage across the cluster
* **Kubernetes / Compute Resources / Namespace (Pods)** — resource usage by namespace
* **Node Exporter / Nodes** — detailed host metrics like disk I/O, network, and CPU

### Querying logs with LogQL

In Grafana's Explore view, select Loki as the data source and try queries like:

```
# All logs from the services namespace
{namespace="services"}

# Logs from pods matching a pattern
{pod=~"miniflux.*"}

# Filter by log content
{namespace="services"} |= "error"

# Parse JSON logs and filter
{namespace="services"} | json | level="error"
```

### Creating alerts

Prometheus supports alerting rules that can notify you when something goes wrong. The kube-prometheus-stack includes many default alerts for common issues like high CPU usage, pod crashes, and node problems. These can be customised via PrometheusRule CRDs.

## Summary

With Prometheus, Grafana, Loki, and Alloy deployed, I now have complete visibility into the k3s cluster:

* **Metrics** — Prometheus collects and stores time-series data from all components
* **Logs** — Loki aggregates logs from all containers, searchable via Grafana
* **Visualisation** — Grafana provides dashboards and exploration tools
* **Alerting** — Alertmanager can notify on conditions defined in Prometheus rules

This observability stack runs entirely on the home lab infrastructure, with data persisted to the NFS share. It's lightweight enough for a three-node cluster but provides the same capabilities as production-grade setups.

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
