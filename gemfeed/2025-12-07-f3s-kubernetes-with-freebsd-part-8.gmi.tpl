# f3s: Kubernetes with FreeBSD - Part 8: Observability

> Published at 2025-12-06T23:58:24+02:00, last updated Mon 09 Mar 09:33:08 EET 2026

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
* Application manifests organized under `argocd-apps/{monitoring,services,infra,test}/`
* Resources organized under `prometheus/manifests/`, `loki/`, etc.
* Justfiles updated to trigger ArgoCD syncs instead of direct Helm commands

The deployment concepts and architecture remain the same—only the deployment method changed from imperative (`helm install/upgrade`) to declarative (GitOps with ArgoCD). 

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

The disk I/O panels in the Node Exporter dashboards will show "No data" for FreeBSD hosts. FreeBSD does expose ZFS-specific metrics (`node_zfs_arcstats_*`) for ARC cache performance, and per-dataset I/O stats are available via `sysctl kstat.zfs`, but mapping these to the Linux-style metrics the dashboards expect is non-trivial. Custom ZFS-specific dashboards are covered later in this post.

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

> Updated Mon 09 Mar: Added section about enabling etcd metrics

## Enabling etcd metrics in k3s

The etcd dashboard in Grafana initially showed no data because k3s uses an embedded etcd that doesn't expose metrics by default.

On each control-plane node (r0, r1, r2), create /etc/rancher/k3s/config.yaml:

```
etcd-expose-metrics: true
```

Then restart k3s on each node:

```
systemctl restart k3s
```

After restarting, etcd metrics are available on port 2381:

```
curl http://127.0.0.1:2381/metrics | grep etcd
```

### Configuring Prometheus to scrape etcd

In persistence-values.yaml, enable kubeEtcd with the node IP addresses:

```
kubeEtcd:
  enabled: true
  endpoints:
    - 192.168.1.120
    - 192.168.1.121
    - 192.168.1.122
  service:
    enabled: true
    port: 2381
    targetPort: 2381
```

Apply the changes:

```
just upgrade
```

### Verifying etcd metrics

After the changes, all etcd targets are being scraped:

```
kubectl exec -n monitoring prometheus-prometheus-kube-prometheus-prometheus-0 \
  -c prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=etcd_server_has_leader' | \
  jq -r '.data.result[] | "\(.metric.instance): \(.value[1])"'
```

Output:

```
192.168.1.120:2381: 1
192.168.1.121:2381: 1
192.168.1.122:2381: 1
```

The etcd dashboard in Grafana now displays metrics including Raft proposals, leader elections, and peer round trip times.

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-etcd-dashboard.png Grafana etcd dashboard showing cluster health, RPC rate, disk sync duration, and peer round trip times

### Complete persistence-values.yaml

The complete updated persistence-values.yaml:

```
kubeEtcd:
  enabled: true
  endpoints:
    - 192.168.1.120
    - 192.168.1.121
    - 192.168.1.122
  service:
    enabled: true
    port: 2381
    targetPort: 2381

prometheus:
  prometheusSpec:
    additionalScrapeConfigsSecret:
      enabled: true
      name: additional-scrape-configs
      key: additional-scrape-configs.yaml
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: ""
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 10Gi
          selector:
            matchLabels:
              type: local
              app: prometheus

grafana:
  persistence:
    enabled: true
    type: pvc
    existingClaim: "grafana-data-pvc"

  initChownData:
    enabled: false

  podSecurityContext:
    fsGroup: 911
    runAsUser: 911
    runAsGroup: 911
```

> Updated Mon 09 Mar: Added section about ZFS monitoring for FreeBSD servers

## ZFS Monitoring for FreeBSD Servers

The FreeBSD servers (f0, f1, f2) that provide NFS storage to the k3s cluster have ZFS filesystems. Monitoring ZFS performance is crucial for understanding storage performance and cache efficiency.

### Node Exporter ZFS Collector

The node_exporter running on each FreeBSD server (v1.9.1) includes a built-in ZFS collector that exposes metrics via sysctls. The ZFS collector is enabled by default and provides:

* ARC (Adaptive Replacement Cache) statistics
* Cache hit/miss rates
* Memory usage and allocation
* MRU/MFU cache breakdown
* Data vs metadata distribution

### Verifying ZFS Metrics

On any FreeBSD server, check that ZFS metrics are being exposed:

```
paul@f0:~ % curl -s http://localhost:9100/metrics | grep node_zfs_arcstats | wc -l
      69
```

The metrics are automatically scraped by Prometheus through the existing static configuration in additional-scrape-configs.yaml which targets all FreeBSD servers on port 9100 with the os: freebsd label.

### ZFS Recording Rules

Created recording rules for easier dashboard consumption in zfs-recording-rules.yaml:

```
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: freebsd-zfs-rules
  namespace: monitoring
  labels:
    release: prometheus
spec:
  groups:
    - name: freebsd-zfs-arc
      interval: 30s
      rules:
        - record: node_zfs_arc_hit_rate_percent
          expr: |
            100 * (
              rate(node_zfs_arcstats_hits_total{os="freebsd"}[5m]) /
              (rate(node_zfs_arcstats_hits_total{os="freebsd"}[5m]) +
               rate(node_zfs_arcstats_misses_total{os="freebsd"}[5m]))
            )
          labels:
            os: freebsd
        - record: node_zfs_arc_memory_usage_percent
          expr: |
            100 * (
              node_zfs_arcstats_size_bytes{os="freebsd"} /
              node_zfs_arcstats_c_max_bytes{os="freebsd"}
            )
          labels:
            os: freebsd
        # Additional rules for metadata %, target %, MRU/MFU %, etc.
```

These recording rules calculate:

* ARC hit rate percentage
* ARC memory usage percentage (current vs maximum)
* ARC target percentage (target vs maximum)
* Metadata vs data percentages
* MRU vs MFU cache percentages
* Demand data and metadata hit rates

### Grafana Dashboards

Created two comprehensive ZFS monitoring dashboards (zfs-dashboards.yaml):

**Dashboard 1: FreeBSD ZFS (per-host detailed view)**

Includes variables to select:

* FreeBSD server (f0, f1, or f2)
* ZFS pool (zdata, zroot, or all)

Pool Overview Row:

* Pool Capacity gauge (with thresholds: green <70%, yellow <85%, red >85%)
* Pool Health status (ONLINE/DEGRADED/FAULTED with color coding)
* Total Pool Size stat
* Free Space stat
* Pool Space Usage Over Time (stacked: used + free)
* Pool Capacity Trend time series

Dataset Statistics Row:

* Table showing all datasets with columns: Pool, Dataset, Used, Available, Referenced
* Automatically filters by selected pool

ARC Cache Statistics Row:

* ARC Hit Rate gauge (red <70%, yellow <90%, green >=90%)
* ARC Size time series (current, target, max)
* ARC Memory Usage percentage gauge
* ARC Hits vs Misses rate
* ARC Data vs Metadata stacked time series

**Dashboard 2: FreeBSD ZFS Summary (cluster-wide overview)**

Cluster-Wide Pool Statistics Row:

* Total Storage Capacity across all servers
* Total Used space
* Total Free space
* Average Pool Capacity gauge
* Pool Health Status (worst case across cluster)
* Total Pool Space Usage Over Time
* Per-Pool Capacity time series (all pools on all hosts)

Per-Host Pool Breakdown Row:

* Bar gauge showing capacity by host and pool
* Table with all pools: Host, Pool, Size, Used, Free, Capacity %, Health

Cluster-Wide ARC Statistics Row:

* Average ARC Hit Rate gauge across all hosts
* ARC Hit Rate by Host time series
* Total ARC Size Across Cluster
* Total ARC Hits vs Misses (cluster-wide sum)
* ARC Size by Host

Dashboard Visualization:

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-zfs-dashboard.png ZFS monitoring dashboard in Grafana showing pool capacity, health, and I/O throughput
=> ./f3s-kubernetes-with-freebsd-part-8/grafana-zfs-arc-stats.png ZFS ARC cache statistics showing hit rate, memory usage, and size trends
=> ./f3s-kubernetes-with-freebsd-part-8/grafana-zfs-datasets.png ZFS datasets table and ARC data vs metadata breakdown

### Deployment

Applied the resources to the cluster:

```
cd /home/paul/git/conf/f3s/prometheus
kubectl apply -f zfs-recording-rules.yaml
kubectl apply -f zfs-dashboards.yaml
```

Updated Justfile to include ZFS recording rules in install and upgrade targets:

```
install:
    kubectl apply -f persistent-volumes.yaml
    kubectl create secret generic additional-scrape-configs --from-file=additional-scrape-configs.yaml -n monitoring --dry-run=client -o yaml | kubectl apply -f -
    helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring -f persistence-values.yaml
    kubectl apply -f freebsd-recording-rules.yaml
    kubectl apply -f openbsd-recording-rules.yaml
    kubectl apply -f zfs-recording-rules.yaml
    just -f grafana-ingress/Justfile install
```

### Verifying ZFS Metrics in Prometheus

Check that ZFS metrics are being collected:

```
kubectl exec -n monitoring prometheus-prometheus-kube-prometheus-prometheus-0 -c prometheus -- \
  wget -qO- 'http://localhost:9090/api/v1/query?query=node_zfs_arcstats_size_bytes'
```

Check recording rules are calculating correctly:

```
kubectl exec -n monitoring prometheus-prometheus-kube-prometheus-prometheus-0 -c prometheus -- \
  wget -qO- 'http://localhost:9090/api/v1/query?query=node_zfs_arc_memory_usage_percent'
```

Example output shows memory usage percentage for each FreeBSD server:

```
"result":[
  {"metric":{"instance":"192.168.2.130:9100","os":"freebsd"},"value":[...,"37.58"]},
  {"metric":{"instance":"192.168.2.131:9100","os":"freebsd"},"value":[...,"12.85"]},
  {"metric":{"instance":"192.168.2.132:9100","os":"freebsd"},"value":[...,"13.44"]}
]
```

### Key Metrics to Monitor

* ARC Hit Rate: Should typically be above 90% for optimal performance. Lower hit rates indicate the ARC cache is too small or workload has poor locality.
* ARC Memory Usage: Shows how much of the maximum ARC size is being used. If consistently at or near maximum, the ARC is effectively utilizing available memory.
* Data vs Metadata: Typically data should dominate, but workloads with many small files will show higher metadata percentages.
* MRU vs MFU: Most Recently Used vs Most Frequently Used cache. The ratio depends on workload characteristics.
* Pool Capacity: Monitor pool usage to ensure adequate free space. ZFS performance degrades when pools exceed 80% capacity.
* Pool Health: Should always show ONLINE (green). DEGRADED (yellow) indicates a disk issue requiring attention. FAULTED (red) requires immediate action.
* Dataset Usage: Track which datasets are consuming the most space to identify growth trends and plan capacity.

### ZFS Pool and Dataset Metrics via Textfile Collector

To complement the ARC statistics from node_exporter's built-in ZFS collector, I added pool capacity and dataset metrics using the textfile collector feature.

Created a script at `/usr/local/bin/zfs_pool_metrics.sh` on each FreeBSD server:

```
#!/bin/sh
# ZFS Pool and Dataset Metrics Collector for Prometheus

OUTPUT_FILE="/var/tmp/node_exporter/zfs_pools.prom.$$"
FINAL_FILE="/var/tmp/node_exporter/zfs_pools.prom"

mkdir -p /var/tmp/node_exporter

{
    # Pool metrics
    echo "# HELP zfs_pool_size_bytes Total size of ZFS pool"
    echo "# TYPE zfs_pool_size_bytes gauge"
    echo "# HELP zfs_pool_allocated_bytes Allocated space in ZFS pool"
    echo "# TYPE zfs_pool_allocated_bytes gauge"
    echo "# HELP zfs_pool_free_bytes Free space in ZFS pool"
    echo "# TYPE zfs_pool_free_bytes gauge"
    echo "# HELP zfs_pool_capacity_percent Capacity percentage"
    echo "# TYPE zfs_pool_capacity_percent gauge"
    echo "# HELP zfs_pool_health Pool health (0=ONLINE, 1=DEGRADED, 2=FAULTED)"
    echo "# TYPE zfs_pool_health gauge"

    zpool list -Hp -o name,size,allocated,free,capacity,health | \
    while IFS=$'\t' read name size alloc free cap health; do
        case "$health" in
            ONLINE)   health_val=0 ;;
            DEGRADED) health_val=1 ;;
            FAULTED)  health_val=2 ;;
            *)        health_val=6 ;;
        esac
        cap_num=$(echo "$cap" | sed 's/%//')

        echo "zfs_pool_size_bytes{pool=\"$name\"} $size"
        echo "zfs_pool_allocated_bytes{pool=\"$name\"} $alloc"
        echo "zfs_pool_free_bytes{pool=\"$name\"} $free"
        echo "zfs_pool_capacity_percent{pool=\"$name\"} $cap_num"
        echo "zfs_pool_health{pool=\"$name\"} $health_val"
    done

    # Dataset metrics
    echo "# HELP zfs_dataset_used_bytes Used space in dataset"
    echo "# TYPE zfs_dataset_used_bytes gauge"
    echo "# HELP zfs_dataset_available_bytes Available space"
    echo "# TYPE zfs_dataset_available_bytes gauge"
    echo "# HELP zfs_dataset_referenced_bytes Referenced space"
    echo "# TYPE zfs_dataset_referenced_bytes gauge"

    zfs list -Hp -t filesystem -o name,used,available,referenced | \
    while IFS=$'\t' read name used avail ref; do
        pool=$(echo "$name" | cut -d/ -f1)
        echo "zfs_dataset_used_bytes{pool=\"$pool\",dataset=\"$name\"} $used"
        echo "zfs_dataset_available_bytes{pool=\"$pool\",dataset=\"$name\"} $avail"
        echo "zfs_dataset_referenced_bytes{pool=\"$pool\",dataset=\"$name\"} $ref"
    done
} > "$OUTPUT_FILE"

mv "$OUTPUT_FILE" "$FINAL_FILE"
```

Deployed to all FreeBSD servers:

```
for host in f0 f1 f2; do
    scp /tmp/zfs_pool_metrics.sh paul@$host:/tmp/
    ssh paul@$host 'doas mv /tmp/zfs_pool_metrics.sh /usr/local/bin/ && \
                    doas chmod +x /usr/local/bin/zfs_pool_metrics.sh'
done
```

Set up cron jobs to run every minute:

```
for host in f0 f1 f2; do
    ssh paul@$host 'echo "* * * * * /usr/local/bin/zfs_pool_metrics.sh >/dev/null 2>&1" | \
                    doas crontab -'
done
```

The textfile collector (already configured with --collector.textfile.directory=/var/tmp/node_exporter) automatically picks up the metrics.

Verify metrics are being exposed:

```
paul@f0:~ % curl -s http://localhost:9100/metrics | grep "^zfs_pool" | head -5
zfs_pool_allocated_bytes{pool="zdata"} 6.47622733824e+11
zfs_pool_allocated_bytes{pool="zroot"} 5.3338578944e+10
zfs_pool_capacity_percent{pool="zdata"} 64
zfs_pool_capacity_percent{pool="zroot"} 10
zfs_pool_free_bytes{pool="zdata"} 3.48809678848e+11
```

> Updated Mon 09 Mar: Added section about distributed tracing with Grafana Tempo

## Distributed Tracing with Grafana Tempo

After implementing logs (Loki) and metrics (Prometheus), the final pillar of observability is distributed tracing. Grafana Tempo provides distributed tracing capabilities that help understand request flows across microservices.

How will this look tracing with Tempo like in Grafana? Have a look at the X-RAG blog post of mine:

=> ./2025-12-24-x-rag-observability-hackathon.gmi X-RAG Observability Hackathon

### Why Distributed Tracing?

In a microservices architecture, a single user request may traverse multiple services. Distributed tracing:

* Tracks requests across service boundaries
* Identifies performance bottlenecks
* Visualizes service dependencies
* Correlates with logs and metrics
* Helps debug complex distributed systems

### Deploying Grafana Tempo

Tempo is deployed in monolithic mode, following the same pattern as Loki's SingleBinary deployment.

#### Configuration Strategy

**Deployment Mode:** Monolithic (all components in one process)
* Simpler operation than microservices mode
* Suitable for the cluster scale
* Consistent with Loki deployment pattern

**Storage:** Filesystem backend using hostPath
* 10Gi storage at /data/nfs/k3svolumes/tempo/data
* 7-day retention (168h)
* Local storage is the only option for monolithic mode

**OTLP Receivers:** Standard OpenTelemetry Protocol ports
* gRPC: 4317
* HTTP: 4318
* Bind to 0.0.0.0 to avoid Tempo 2.7+ localhost-only binding issue

#### Tempo Deployment Files

Created in /home/paul/git/conf/f3s/tempo/:

**values.yaml** - Helm chart configuration:

```
tempo:
  retention: 168h
  storage:
    trace:
      backend: local
      local:
        path: /var/tempo/traces
      wal:
        path: /var/tempo/wal
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318

persistence:
  enabled: true
  size: 10Gi
  storageClassName: ""

resources:
  limits:
    cpu: 1000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 1Gi
```

**persistent-volumes.yaml** - Storage configuration:

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: tempo-data-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/nfs/k3svolumes/tempo/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: tempo-data-pvc
  namespace: monitoring
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

**Grafana Datasource Provisioning**

All Grafana datasources (Prometheus, Alertmanager, Loki, Tempo) are provisioned via a unified ConfigMap that is directly mounted to the Grafana pod. This approach ensures datasources are loaded on startup without requiring sidecar-based discovery.

In /home/paul/git/conf/f3s/prometheus/grafana-datasources-all.yaml:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources-all
  namespace: monitoring
data:
  datasources.yaml: |
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        uid: prometheus
        url: http://prometheus-kube-prometheus-prometheus.monitoring:9090/
        access: proxy
        isDefault: true
      - name: Alertmanager
        type: alertmanager
        uid: alertmanager
        url: http://prometheus-kube-prometheus-alertmanager.monitoring:9093/
      - name: Loki
        type: loki
        uid: loki
        url: http://loki.monitoring.svc.cluster.local:3100
      - name: Tempo
        type: tempo
        uid: tempo
        url: http://tempo.monitoring.svc.cluster.local:3200
        jsonData:
          tracesToLogsV2:
            datasourceUid: loki
            spanStartTimeShift: -1h
            spanEndTimeShift: 1h
          tracesToMetrics:
            datasourceUid: prometheus
          serviceMap:
            datasourceUid: prometheus
          nodeGraph:
            enabled: true
```

The kube-prometheus-stack Helm values (persistence-values.yaml) are configured to:
* Disable sidecar-based datasource provisioning
* Mount grafana-datasources-all ConfigMap directly to /etc/grafana/provisioning/datasources/

This direct mounting approach is simpler and more reliable than sidecar-based discovery.

#### Installation

```
cd /home/paul/git/conf/f3s/tempo
just install
```

Verify Tempo is running:

```
kubectl get pods -n monitoring -l app.kubernetes.io/name=tempo
kubectl exec -n monitoring <tempo-pod> -- wget -qO- http://localhost:3200/ready
```

### Configuring Grafana Alloy for Trace Collection

Updated /home/paul/git/conf/f3s/loki/alloy-values.yaml to add OTLP receivers for traces while maintaining existing log collection.

#### OTLP Receiver Configuration

Added to Alloy configuration after the log collection pipeline:

```
// OTLP receiver for traces via gRPC and HTTP
otelcol.receiver.otlp "default" {
  grpc {
    endpoint = "0.0.0.0:4317"
  }
  http {
    endpoint = "0.0.0.0:4318"
  }
  output {
    traces = [otelcol.processor.batch.default.input]
  }
}

// Batch processor for efficient trace forwarding
otelcol.processor.batch "default" {
  timeout = "5s"
  send_batch_size = 100
  send_batch_max_size = 200
  output {
    traces = [otelcol.exporter.otlp.tempo.input]
  }
}

// OTLP exporter to send traces to Tempo
otelcol.exporter.otlp "tempo" {
  client {
    endpoint = "tempo.monitoring.svc.cluster.local:4317"
    tls {
      insecure = true
    }
    compression = "gzip"
  }
}
```

The batch processor reduces network overhead by accumulating spans before forwarding to Tempo.

#### Upgrade Alloy

```
cd /home/paul/git/conf/f3s/loki
just upgrade
```

Verify OTLP receivers are listening:

```
kubectl logs -n monitoring -l app.kubernetes.io/name=alloy | grep -i "otlp.*receiver"
kubectl exec -n monitoring <alloy-pod> -- netstat -ln | grep -E ':(4317|4318)'
```

### Demo Tracing Application

Created a three-tier Python application to demonstrate distributed tracing in action.

#### Application Architecture

```
User → Frontend (Flask:5000) → Middleware (Flask:5001) → Backend (Flask:5002)
           ↓                          ↓                        ↓
                    Alloy (OTLP:4317) → Tempo → Grafana
```

Frontend Service:

* Receives HTTP requests at /api/process
* Forwards to middleware service
* Creates parent span for the entire request

Middleware Service:

* Transforms data at /api/transform
* Calls backend service
* Creates child span linked to frontend

Backend Service:

* Returns data at /api/data
* Simulates database query (100ms sleep)
* Creates leaf span in the trace

OpenTelemetry Instrumentation:

All services use Python OpenTelemetry libraries:

**Dependencies:**
```
flask==3.0.0
requests==2.31.0
opentelemetry-distro==0.49b0
opentelemetry-exporter-otlp==1.28.0
opentelemetry-instrumentation-flask==0.49b0
opentelemetry-instrumentation-requests==0.49b0
```

**Auto-instrumentation pattern** (used in all services):

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor
from opentelemetry.sdk.resources import Resource

# Define service identity
resource = Resource(attributes={
    "service.name": "frontend",
    "service.namespace": "tracing-demo",
    "service.version": "1.0.0"
})

provider = TracerProvider(resource=resource)

# Export to Alloy
otlp_exporter = OTLPSpanExporter(
    endpoint="http://alloy.monitoring.svc.cluster.local:4317",
    insecure=True
)

processor = BatchSpanProcessor(otlp_exporter)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

# Auto-instrument Flask and requests
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()
```

The auto-instrumentation automatically:
* Creates spans for HTTP requests
* Propagates trace context via W3C Trace Context headers
* Links parent and child spans across service boundaries

Deployment:

Created Helm chart in /home/paul/git/conf/f3s/tracing-demo/ with three separate deployments, services, and an ingress.

Build and deploy:

```
cd /home/paul/git/conf/f3s/tracing-demo
just build
just import
just install
```

Verify deployment:

```
kubectl get pods -n services | grep tracing-demo
kubectl get ingress -n services tracing-demo-ingress
```

Access the application at:

=> http://tracing-demo.f3s.buetow.org

### Visualizing Traces in Grafana

The Tempo datasource is automatically discovered by Grafana through the ConfigMap label.

#### Accessing Traces

Navigate to Grafana → Explore → Select "Tempo" datasource

**Search Interface:**
* Search by Trace ID
* Search by service name
* Search by tags

**TraceQL Queries:**

Find all traces from demo app:
```
{ resource.service.namespace = "tracing-demo" }
```

Find slow requests (>200ms):
```
{ duration > 200ms }
```

Find traces from specific service:
```
{ resource.service.name = "frontend" }
```

Find errors:
```
{ status = error }
```

Complex query - frontend traces calling middleware:
```
{ resource.service.namespace = "tracing-demo" } && { span.http.status_code >= 500 }
```

#### Service Graph Visualization

The service graph shows visual connections between services:

1. Navigate to Explore → Tempo
2. Enable "Service Graph" view
3. Shows: Frontend → Middleware → Backend with request rates

The service graph uses Prometheus metrics generated from trace data.

### Correlation Between Observability Signals

Tempo integrates with Loki and Prometheus to provide unified observability.

#### Traces-to-Logs

Click on any span in a trace to see related logs:

1. View trace in Grafana
2. Click on a span
3. Select "Logs for this span"
4. Loki shows logs filtered by:
   * Time range (span duration ± 1 hour)
   * Service name
   * Namespace
   * Pod

This helps correlate what the service was doing when the span was created.

#### Traces-to-Metrics

View Prometheus metrics for services in the trace:

1. View trace in Grafana
2. Select "Metrics" tab
3. Shows metrics like:
   * Request rate
   * Error rate
   * Duration percentiles

#### Logs-to-Traces

From logs, you can jump to related traces:

1. In Loki, logs that contain trace IDs are automatically linked
2. Click the trace ID to view the full trace
3. See the complete request flow

### Generating Traces for Testing

Test the demo application:

```
curl http://tracing-demo.f3s.buetow.org/api/process
```

Load test (generates 50 traces):

```
cd /home/paul/git/conf/f3s/tracing-demo
just load-test
```

Each request creates a distributed trace spanning all three services.

### Verifying the Complete Pipeline

Check the trace flow end-to-end:

**1. Application generates traces:**
```
kubectl logs -n services -l app=tracing-demo-frontend | grep -i trace
```

**2. Alloy receives traces:**
```
kubectl logs -n monitoring -l app.kubernetes.io/name=alloy | grep -i otlp
```

**3. Tempo stores traces:**
```
kubectl logs -n monitoring -l app.kubernetes.io/name=tempo | grep -i trace
```

**4. Grafana displays traces:**
Navigate to Explore → Tempo → Search for traces

### Practical Example: Viewing a Distributed Trace

Let's generate a trace and examine it in Grafana.

**1. Generate a trace by calling the demo application:**

```
curl -H "Host: tracing-demo.f3s.buetow.org" http://r0/api/process
```

**Response (HTTP 200):**

```json
{
  "middleware_response": {
    "backend_data": {
      "data": {
        "id": 12345,
        "query_time_ms": 100.0,
        "timestamp": "2025-12-28T18:35:01.064538",
        "value": "Sample data from backend service"
      },
      "service": "backend"
    },
    "middleware_processed": true,
    "original_data": {
      "source": "GET request"
    },
    "transformation_time_ms": 50
  },
  "request_data": {
    "source": "GET request"
  },
  "service": "frontend",
  "status": "success"
}
```

**2. Find the trace in Tempo via API:**

After a few seconds (for batch export), search for recent traces:

```
kubectl exec -n monitoring tempo-0 -- wget -qO- \
  'http://localhost:3200/api/search?tags=service.namespace%3Dtracing-demo&limit=5' 2>/dev/null | \
  python3 -m json.tool
```

Returns traces including:

```json
{
  "traceID": "4be1151c0bdcd5625ac7e02b98d95bd5",
  "rootServiceName": "frontend",
  "rootTraceName": "GET /api/process",
  "durationMs": 221
}
```

**3. Fetch complete trace details:**

```
kubectl exec -n monitoring tempo-0 -- wget -qO- \
  'http://localhost:3200/api/traces/4be1151c0bdcd5625ac7e02b98d95bd5' 2>/dev/null | \
  python3 -m json.tool
```

**Trace structure (8 spans across 3 services):**

```
Trace ID: 4be1151c0bdcd5625ac7e02b98d95bd5
Services: 3 (frontend, middleware, backend)

Service: frontend
  └─ GET /api/process                 221.10ms  (HTTP server span)
  └─ frontend-process                 216.23ms  (custom business logic span)
  └─ POST                             209.97ms  (HTTP client span to middleware)

Service: middleware
  └─ POST /api/transform              186.02ms  (HTTP server span)
  └─ middleware-transform             180.96ms  (custom business logic span)
  └─ GET                              127.52ms  (HTTP client span to backend)

Service: backend
  └─ GET /api/data                    103.93ms  (HTTP server span)
  └─ backend-get-data                 102.11ms  (custom business logic span with 100ms sleep)
```

**4. View the trace in Grafana UI:**

Navigate to: Grafana → Explore → Tempo datasource

Search using TraceQL:
```
{ resource.service.namespace = "tracing-demo" }
```

Or directly open the trace by pasting the trace ID in the search box:
```
4be1151c0bdcd5625ac7e02b98d95bd5
```

**5. Trace visualization:**

The trace waterfall view in Grafana shows the complete request flow with timing:

=> ./f3s-kubernetes-with-freebsd-part-8/grafana-tempo-trace.png Distributed trace visualization in Grafana Tempo showing Frontend → Middleware → Backend spans

For additional examples of Tempo trace visualization, see also:

=> https://foo.zone/gemfeed/2025-12-24-x-rag-observability-hackathon.html X-RAG Observability Hackathon (more Grafana Tempo screenshots)

The trace reveals the distributed request flow:

* Frontend (221ms): Receives GET /api/process, executes business logic, calls middleware
* Middleware (186ms): Receives POST /api/transform, transforms data, calls backend
* Backend (104ms): Receives GET /api/data, simulates database query with 100ms sleep
* Total request time: 221ms end-to-end
* Span propagation: W3C Trace Context headers automatically link all spans

**6. Service graph visualization:**

The service graph is automatically generated from traces and shows service dependencies. For examples of service graph visualization in Grafana, see the screenshots in the X-RAG Observability Hackathon blog post.

=> ./2025-12-24-x-rag-observability-hackathon.gmi X-RAG Observability Hackathon (includes service graph screenshots)

This visualization helps identify:

* Request rates between services
* Average latency for each hop
* Error rates (if any)
* Service dependencies and communication patterns

### Storage and Retention

Monitor Tempo storage usage:

```
kubectl exec -n monitoring <tempo-pod> -- df -h /var/tempo
```

With 10Gi storage and 7-day retention, the system handles moderate trace volumes. If storage fills up:

* Reduce retention to 72h (3 days)
* Implement sampling in Alloy
* Increase PV size

### Configuration Files

All configuration files are available on Codeberg:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/tempo Tempo configuration
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/loki Alloy configuration (updated for traces)
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/tracing-demo Demo tracing application

## Summary

With Prometheus, Grafana, Loki, Alloy, and Tempo deployed, I now have complete visibility into the k3s cluster, the FreeBSD storage servers, and the OpenBSD edge relays:

* Metrics: Prometheus collects and stores time-series data from all components, including etcd and ZFS
* Logs: Loki aggregates logs from all containers, searchable via Grafana
* Traces: Tempo provides distributed request tracing with service dependency mapping
* Visualisation: Grafana provides dashboards and exploration tools with correlation between all three signals
* Alerting: Alertmanager can notify on conditions defined in Prometheus rules

This observability stack runs entirely on the home lab infrastructure, with data persisted to the NFS share. It's lightweight enough for a three-node cluster but provides the same capabilities as production-grade setups.

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/prometheus prometheus configuration on Codeberg

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
