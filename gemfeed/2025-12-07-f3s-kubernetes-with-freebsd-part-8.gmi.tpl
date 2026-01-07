# f3s: Kubernetes with FreeBSD - Part 8: Observability

> Published at 2025-12-06T23:58:24+02:00

This is the 8th blog post about the f3s series for my self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution I use on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, I set up a complete observability stack for the k3s cluster. Observability is crucial for understanding what's happening inside the cluster—whether its tracking resource usage, debugging issues, or analysing application behaviour. The stack consists of four main components, all deployed into the `monitoring` namespace:

* Prometheus: time-series database for metrics collection and alerting
* Grafana: visualisation and dashboarding frontend
* Loki: log aggregation system (like Prometheus, but for logs)
* Alloy: telemetry collector that ships logs from all pods to Loki

Together, these form the "PLG" stack (Prometheus, Loki, Grafana), which is a popular open-source alternative to commercial observability platforms.

All manifests for the f3s stack live in my configuration repository:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s codeberg.org/snonux/conf/f3s

## Important Note: GitOps Migration

**Note:** After publishing this blog post, the f3s cluster was migrated from imperative Helm deployments to declarative GitOps using ArgoCD. The Kubernetes manifests, Helm charts, and Justfiles in the repository have been reorganized for ArgoCD-based continuous deployment.

**To view the exact configuration as it existed when this blog post was written** (before the ArgoCD migration), check out the pre-ArgoCD revision:

```sh
$ git clone https://codeberg.org/snonux/conf.git
$ cd conf
$ git checkout 15a86f3  # Last commit before ArgoCD migration
$ cd f3s/prometheus/
```

**Current master branch** contains the ArgoCD-managed versions with:
- Application manifests organized under `argocd-apps/{monitoring,services,infra,test}/`
- Resources organized under `prometheus/manifests/`, `loki/`, etc.
- Justfiles updated to trigger ArgoCD syncs instead of direct Helm commands

The deployment concepts and architecture remain the same—only the deployment method changed from imperative (`helm install/upgrade`) to declarative (GitOps with ArgoCD). For details on the GitOps migration, see Part X of this series. 

## Persistent storage recap

All observability components need persistent storage so that metrics and logs survive pod restarts. As covered in Part 6 of this series, the cluster uses NFS-backed persistent volumes:

=> ./2025-07-14-f3s-kubernetes-with-freebsd-part-6.gmi f3s: Kubernetes with FreeBSD - Part 6: Storage

The FreeBSD hosts (`f0`, `f1`) serve as master-standby NFS servers, exporting ZFS datasets that are replicated across hosts using `zrepl`. The Rocky Linux k3s nodes (`r0`, `r1`, `r2`) mount these exports at `/data/nfs/k3svolumes`. This directory contains subdirectories for each application that needs persistent storage—including Prometheus, Grafana, and Loki.

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

Prometheus and Grafana are deployed together using the `kube-prometheus-stack` Helm chart from the Prometheus community. This chart bundles Prometheus, Grafana, Alertmanager, and various exporters (Node Exporter, Kube State Metrics) into a single deployment. Ill explain what each component does in detail later when we look at the running pods.

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

The `persistence-values.yaml` configures Prometheus and Grafana to use the NFS-backed persistent volumes I mentioned earlier, ensuring data survives pod restarts. It also enables scraping of etcd and kube-controller-manager metrics:

```yaml
kubeEtcd:
  enabled: true
  endpoints:
    - 192.168.2.120
    - 192.168.2.121
    - 192.168.2.122
  service:
    enabled: true
    port: 2381
    targetPort: 2381

kubeControllerManager:
  enabled: true
  endpoints:
    - 192.168.2.120
    - 192.168.2.121
    - 192.168.2.122
  service:
    enabled: true
    port: 10257
    targetPort: 10257
  serviceMonitor:
    enabled: true
    https: true
    insecureSkipVerify: true
```

By default, k3s binds the controller-manager to localhost only, so the "Kubernetes / Controller Manager" dashboard in Grafana will show no data. To expose the metrics endpoint, add the following to `/etc/rancher/k3s/config.yaml` on each k3s server node:

```sh
[root@r0 ~]# cat >> /etc/rancher/k3s/config.yaml << 'EOF'
kube-controller-manager-arg:
  - bind-address=0.0.0.0
EOF
[root@r0 ~]# systemctl restart k3s
```

Repeat for `r1` and `r2`. After restarting all nodes, the controller-manager metrics endpoint will be accessible and Prometheus can scrape it.

The persistent volume definitions bind to specific paths on the NFS share using `hostPath` volumes—the same pattern used for other services in Part 7:

=> ./2025-10-02-f3s-kubernetes-with-freebsd-part-7.gmi f3s: Kubernetes with FreeBSD - Part 7: k3s and first pod deployments

### Exposing Grafana via ingress

The chart also deploys an ingress for Grafana, making it accessible at `grafana.f3s.foo.zone`. The ingress configuration follows the same pattern as other services in the cluster—Traefik handles the routing internally, while the OpenBSD edge relays terminate TLS and forward traffic through WireGuard.

Once deployed, Grafana is accessible and comes pre-configured with Prometheus as a data source. You can verify the Prometheus service is running:

```sh
$ kubectl get svc -n monitoring prometheus-kube-prometheus-prometheus
NAME                                    TYPE        CLUSTER-IP      PORT(S)
prometheus-kube-prometheus-prometheus   ClusterIP   10.43.152.163   9090/TCP,8080/TCP
```

Grafana connects to Prometheus using the internal service URL `http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090`. The default Grafana credentials are `admin`/`prom-operator`, which should be changed immediately after first login.

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-prometheus.png Grafana dashboard showing Prometheus metrics

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-dashboard.png Grafana dashboard showing cluster metrics

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

```sh
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

  rule {
    source_labels = ["__meta_kubernetes_pod_label_app"]
    target_label  = "app"
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

This configuration automatically labels each log line with the namespace, pod name, container name, and app label, making it easy to filter logs in Grafana.

### Adding Loki as a Grafana data source

Loki doesn't have its own web UI—you query it through Grafana. First, verify the Loki service is running:

```sh
$ kubectl get svc -n monitoring loki
NAME   TYPE        CLUSTER-IP    PORT(S)
loki   ClusterIP   10.43.64.60   3100/TCP,9095/TCP
```

To add Loki as a data source in Grafana:

* Navigate to Configuration → Data Sources
* Click "Add data source"
* Select "Loki"
* Set the URL to: `http://loki.monitoring.svc.cluster.local:3100`
* Click "Save & Test"

Once configured, you can explore logs in Grafana's "Explore" view. I'll show some example queries in the "Using the observability stack" section below.

=> ./f3s-kubernetes-with-freebsd-part-8/loki-explore.png Exploring logs in Grafana with Loki

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

* `alertmanager-prometheus-kube-prometheus-alertmanager-0`: the Alertmanager instance that receives alerts from Prometheus, deduplicates them, groups related alerts together, and routes notifications to the appropriate receivers (email, Slack, PagerDuty, etc.). It runs as a StatefulSet with persistent storage for silences and notification state.

* `alloy-g5fgj, alloy-nfw8w, alloy-tg9vj`: three Alloy pods running as a DaemonSet, one on each k3s node. Each pod tails the container logs from its local node via the Kubernetes API and forwards them to Loki. This ensures log collection continues even if a node becomes isolated from the others.

* `loki-0`: the single Loki instance running in single-binary mode. It receives log streams from Alloy, stores them in chunks on the NFS-backed persistent volume, and serves queries from Grafana. The `-0` suffix indicates it's a StatefulSet pod.

* `prometheus-grafana-...`: the Grafana web interface for visualising metrics and logs. It comes pre-configured with Prometheus as a data source and includes dozens of dashboards for Kubernetes monitoring. Dashboards, users, and settings are persisted to the NFS share.

* `prometheus-kube-prometheus-operator-...`: the Prometheus Operator that watches for custom resources (ServiceMonitor, PodMonitor, PrometheusRule) and automatically configures Prometheus to scrape new targets. This allows applications to declare their own monitoring requirements.

* `prometheus-kube-state-metrics-...`: generates metrics about the state of Kubernetes objects themselves: how many pods are running, pending, or failed; deployment replica counts; node conditions; PVC status; and more. Essential for cluster-level dashboards.

* `prometheus-prometheus-kube-prometheus-prometheus-0`: the Prometheus server that scrapes metrics from all configured targets (pods, services, nodes), stores them in a time-series database, evaluates alerting rules, and serves queries to Grafana.

* `prometheus-prometheus-node-exporter-...`: three Node Exporter pods running as a DaemonSet, one on each node. They expose hardware and OS-level metrics: CPU usage, memory, disk I/O, filesystem usage, network statistics, and more. These feed the "Node Exporter" dashboards in Grafana.

## Using the observability stack

### Viewing metrics in Grafana

The kube-prometheus-stack comes with many pre-built dashboards. Some useful ones include:

* Kubernetes / Compute Resources / Cluster: overview of CPU and memory usage across the cluster
* Kubernetes / Compute Resources / Namespace (Pods): resource usage by namespace
* Node Exporter / Nodes: detailed host metrics like disk I/O, network, and CPU

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

## Monitoring external FreeBSD hosts

The observability stack can also monitor servers outside the Kubernetes cluster. The FreeBSD hosts (`f0`, `f1`, `f2`) that serve NFS storage can be added to Prometheus using the Node Exporter.

### Installing Node Exporter on FreeBSD

On each FreeBSD host, install the node_exporter package:

```sh
paul@f0:~ % doas pkg install -y node_exporter
```

Enable the service to start at boot:

```sh
paul@f0:~ % doas sysrc node_exporter_enable=YES
node_exporter_enable:  -> YES
```

Configure node_exporter to listen on the WireGuard interface. This ensures metrics are only accessible through the secure tunnel, not the public network. Replace the IP with the host's WireGuard address:

```sh
paul@f0:~ % doas sysrc node_exporter_args='--web.listen-address=192.168.2.130:9100'
node_exporter_args:  -> --web.listen-address=192.168.2.130:9100
```

Start the service:

```sh
paul@f0:~ % doas service node_exporter start
Starting node_exporter.
```

Verify it's running:

```sh
paul@f0:~ % curl -s http://192.168.2.130:9100/metrics | head -3
# HELP go_gc_duration_seconds A summary of the wall-time pause...
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
```

Repeat for the other FreeBSD hosts (`f1`, `f2`) with their respective WireGuard IPs.

### Adding FreeBSD hosts to Prometheus

Create a file `additional-scrape-configs.yaml` in the prometheus configuration directory:

```yaml
- job_name: 'node-exporter'
  static_configs:
    - targets:
      - '192.168.2.130:9100'  # f0 via WireGuard
      - '192.168.2.131:9100'  # f1 via WireGuard
      - '192.168.2.132:9100'  # f2 via WireGuard
      labels:
        os: freebsd
```

The `job_name` must be `node-exporter` to match the existing dashboards. The `os: freebsd` label allows filtering these hosts separately if needed.

Create a Kubernetes secret from this file:

```sh
$ kubectl create secret generic additional-scrape-configs \
    --from-file=additional-scrape-configs.yaml \
    -n monitoring
```

Update `persistence-values.yaml` to reference the secret:

```yaml
prometheus:
  prometheusSpec:
    additionalScrapeConfigsSecret:
      enabled: true
      name: additional-scrape-configs
      key: additional-scrape-configs.yaml
```

Upgrade the Prometheus deployment:

```sh
$ just upgrade
```

After a minute or so, the FreeBSD hosts appear in the Prometheus targets and in the Node Exporter dashboards in Grafana.

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-freebsd-nodes.png FreeBSD hosts in the Node Exporter dashboard

### FreeBSD memory metrics compatibility

The default Node Exporter dashboards are designed for Linux and expect metrics like `node_memory_MemAvailable_bytes`. FreeBSD uses different metric names (`node_memory_size_bytes`, `node_memory_free_bytes`, etc.), so memory panels will show "No data" out of the box.

To fix this, I created a PrometheusRule that generates synthetic Linux-compatible metrics from the FreeBSD equivalents:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: freebsd-memory-rules
  namespace: monitoring
  labels:
    release: prometheus
spec:
  groups:
    - name: freebsd-memory
      rules:
        - record: node_memory_MemTotal_bytes
          expr: node_memory_size_bytes{os="freebsd"}
        - record: node_memory_MemAvailable_bytes
          expr: |
            node_memory_free_bytes{os="freebsd"}
              + node_memory_inactive_bytes{os="freebsd"}
              + node_memory_cache_bytes{os="freebsd"}
        - record: node_memory_MemFree_bytes
          expr: node_memory_free_bytes{os="freebsd"}
        - record: node_memory_Buffers_bytes
          expr: node_memory_buffer_bytes{os="freebsd"}
        - record: node_memory_Cached_bytes
          expr: node_memory_cache_bytes{os="freebsd"}
```

This file is saved as `freebsd-recording-rules.yaml` and applied as part of the Prometheus installation. The `os="freebsd"` label (set in the scrape config) ensures these rules only apply to FreeBSD hosts. After applying, the memory panels in the Node Exporter dashboards populate correctly for FreeBSD.

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/prometheus/freebsd-recording-rules.yaml freebsd-recording-rules.yaml on Codeberg

### Disk I/O metrics limitation

Unlike memory metrics, disk I/O metrics (`node_disk_read_bytes_total`, `node_disk_written_bytes_total`, etc.) are not available on FreeBSD. The Linux diskstats collector that provides these metrics doesn't have a FreeBSD equivalent in the node_exporter.

The disk I/O panels in the Node Exporter dashboards will show "No data" for FreeBSD hosts. FreeBSD does expose ZFS-specific metrics (`node_zfs_arcstats_*`) for ARC cache performance, and per-dataset I/O stats are available via `sysctl kstat.zfs`, but mapping these to the Linux-style metrics the dashboards expect is non-trivial. Creating custom ZFS-specific dashboards is left as an exercise for another day.

## Monitoring external OpenBSD hosts

The same approach works for OpenBSD hosts. I have two OpenBSD edge relay servers (`blowfish`, `fishfinger`) that handle TLS termination and forward traffic through WireGuard to the cluster. These can also be monitored with Node Exporter.

### Installing Node Exporter on OpenBSD

On each OpenBSD host, install the node_exporter package:

```sh
blowfish:~ $ doas pkg_add node_exporter
quirks-7.103 signed on 2025-10-13T22:55:16Z
The following new rcscripts were installed: /etc/rc.d/node_exporter
See rcctl(8) for details.
```

Enable the service to start at boot:

```sh
blowfish:~ $ doas rcctl enable node_exporter
```

Configure node_exporter to listen on the WireGuard interface. This ensures metrics are only accessible through the secure tunnel, not the public network. Replace the IP with the host's WireGuard address:

```sh
blowfish:~ $ doas rcctl set node_exporter flags '--web.listen-address=192.168.2.110:9100'
```

Start the service:

```sh
blowfish:~ $ doas rcctl start node_exporter
node_exporter(ok)
```

Verify it's running:

```sh
blowfish:~ $ curl -s http://192.168.2.110:9100/metrics | head -3
# HELP go_gc_duration_seconds A summary of the wall-time pause...
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
```

Repeat for the other OpenBSD host (`fishfinger`) with its respective WireGuard IP (`192.168.2.111`).

### Adding OpenBSD hosts to Prometheus

Update `additional-scrape-configs.yaml` to include the OpenBSD targets:

```yaml
- job_name: 'node-exporter'
  static_configs:
    - targets:
      - '192.168.2.130:9100'  # f0 via WireGuard
      - '192.168.2.131:9100'  # f1 via WireGuard
      - '192.168.2.132:9100'  # f2 via WireGuard
      labels:
        os: freebsd
    - targets:
      - '192.168.2.110:9100'  # blowfish via WireGuard
      - '192.168.2.111:9100'  # fishfinger via WireGuard
      labels:
        os: openbsd
```

The `os: openbsd` label allows filtering these hosts separately from FreeBSD and Linux nodes.

### OpenBSD memory metrics compatibility

OpenBSD uses the same memory metric names as FreeBSD (`node_memory_size_bytes`, `node_memory_free_bytes`, etc.), so a similar PrometheusRule is needed to generate Linux-compatible metrics:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: openbsd-memory-rules
  namespace: monitoring
  labels:
    release: prometheus
spec:
  groups:
    - name: openbsd-memory
      rules:
        - record: node_memory_MemTotal_bytes
          expr: node_memory_size_bytes{os="openbsd"}
          labels:
            os: openbsd
        - record: node_memory_MemAvailable_bytes
          expr: |
            node_memory_free_bytes{os="openbsd"}
              + node_memory_inactive_bytes{os="openbsd"}
              + node_memory_cache_bytes{os="openbsd"}
          labels:
            os: openbsd
        - record: node_memory_MemFree_bytes
          expr: node_memory_free_bytes{os="openbsd"}
          labels:
            os: openbsd
        - record: node_memory_Cached_bytes
          expr: node_memory_cache_bytes{os="openbsd"}
          labels:
            os: openbsd
```

This file is saved as `openbsd-recording-rules.yaml` and applied alongside the FreeBSD rules. Note that OpenBSD doesn't expose a buffer memory metric, so that rule is omitted.

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/prometheus/openbsd-recording-rules.yaml openbsd-recording-rules.yaml on Codeberg

After running `just upgrade`, the OpenBSD hosts appear in Prometheus targets and the Node Exporter dashboards.

## Summary

With Prometheus, Grafana, Loki, and Alloy deployed, I now have complete visibility into the k3s cluster, the FreeBSD storage servers, and the OpenBSD edge relays:

* metrics: Prometheus collects and stores time-series data from all components
* Logs: Loki aggregates logs from all containers, searchable via Grafana
* Visualisation: Grafana provides dashboards and exploration tools
* Alerting: Alertmanager can notify on conditions defined in Prometheus rules

This observability stack runs entirely on the home lab infrastructure, with data persisted to the NFS share. It's lightweight enough for a three-node cluster but provides the same capabilities as production-grade setups.

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
