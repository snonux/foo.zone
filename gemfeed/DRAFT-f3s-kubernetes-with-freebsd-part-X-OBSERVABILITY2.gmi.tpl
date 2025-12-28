# f3s: Kubernetes with FreeBSD - Part 9: Enabling etcd Metrics

## Introduction

This post covers enabling etcd metrics monitoring for the k3s cluster. The etcd dashboard in Grafana initially showed no data because k3s uses an embedded etcd that doesn't expose metrics by default.

=> ./2025-12-07-f3s-kubernetes-with-freebsd-part-8.html Part 8: Observability

## Enabling etcd metrics in k3s

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

## Configuring Prometheus to scrape etcd

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

## Verifying etcd metrics

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

## Complete persistence-values.yaml

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

**Pool Overview Row:**
* Pool Capacity gauge (with thresholds: green <70%, yellow <85%, red >85%)
* Pool Health status (ONLINE/DEGRADED/FAULTED with color coding)
* Total Pool Size stat
* Free Space stat
* Pool Space Usage Over Time (stacked: used + free)
* Pool Capacity Trend time series

**Dataset Statistics Row:**
* Table showing all datasets with columns: Pool, Dataset, Used, Available, Referenced
* Automatically filters by selected pool

**ARC Cache Statistics Row:**
* ARC Hit Rate gauge (red <70%, yellow <90%, green >=90%)
* ARC Size time series (current, target, max)
* ARC Memory Usage percentage gauge
* ARC Hits vs Misses rate
* ARC Data vs Metadata stacked time series

**Dashboard 2: FreeBSD ZFS Summary (cluster-wide overview)**

**Cluster-Wide Pool Statistics Row:**
* Total Storage Capacity across all servers
* Total Used space
* Total Free space
* Average Pool Capacity gauge
* Pool Health Status (worst case across cluster)
* Total Pool Space Usage Over Time
* Per-Pool Capacity time series (all pools on all hosts)

**Per-Host Pool Breakdown Row:**
* Bar gauge showing capacity by host and pool
* Table with all pools: Host, Pool, Size, Used, Free, Capacity %, Health

**Cluster-Wide ARC Statistics Row:**
* Average ARC Hit Rate gauge across all hosts
* ARC Hit Rate by Host time series
* Total ARC Size Across Cluster
* Total ARC Hits vs Misses (cluster-wide sum)
* ARC Size by Host

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

### Accessing the Dashboards

The dashboards are automatically imported by the Grafana sidecar and accessible at:

=> https://grafana.f3s.buetow.org

Navigate to Dashboards and search for:
* "FreeBSD ZFS" - detailed per-host view with pool and dataset breakdowns
* "FreeBSD ZFS Summary" - cluster-wide overview of all ZFS storage

### Key Metrics to Monitor

**ARC Hit Rate:** Should typically be above 90% for optimal performance. Lower hit rates indicate the ARC cache is too small or workload has poor locality.

**ARC Memory Usage:** Shows how much of the maximum ARC size is being used. If consistently at or near maximum, the ARC is effectively utilizing available memory.

**Data vs Metadata:** Typically data should dominate, but workloads with many small files will show higher metadata percentages.

**MRU vs MFU:** Most Recently Used vs Most Frequently Used cache. The ratio depends on workload characteristics.

**Pool Capacity:** Monitor pool usage to ensure adequate free space. ZFS performance degrades when pools exceed 80% capacity.

**Pool Health:** Should always show ONLINE (green). DEGRADED (yellow) indicates a disk issue requiring attention. FAULTED (red) requires immediate action.

**Dataset Usage:** Track which datasets are consuming the most space to identify growth trends and plan capacity.

### ZFS Pool and Dataset Metrics via Textfile Collector

To complement the ARC statistics from node_exporter's built-in ZFS collector, I added pool capacity and dataset metrics using the textfile collector feature.

Created a script at /usr/local/bin/zfs_pool_metrics.sh on each FreeBSD server:

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

## Summary

Enhanced the f3s cluster observability by:

* Enabling etcd metrics monitoring for the k3s embedded etcd
* Implementing comprehensive ZFS monitoring for FreeBSD storage servers
* Creating recording rules for calculated metrics (ARC hit rates, memory usage, etc.)
* Deploying Grafana dashboards for visualization
* Configuring automatic dashboard import via ConfigMap labels

The monitoring stack now provides visibility into both cluster control plane health (etcd) and storage performance (ZFS).

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/prometheus prometheus configuration on Codeberg

## Distributed Tracing with Grafana Tempo

After implementing logs (Loki) and metrics (Prometheus), the final pillar of observability is distributed tracing. Grafana Tempo provides distributed tracing capabilities that help understand request flows across microservices.

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

**Frontend Service:**
* Receives HTTP requests at /api/process
* Forwards to middleware service
* Creates parent span for the entire request

**Middleware Service:**
* Transforms data at /api/transform
* Calls backend service
* Creates child span linked to frontend

**Backend Service:**
* Returns data at /api/data
* Simulates database query (100ms sleep)
* Creates leaf span in the trace

#### OpenTelemetry Instrumentation

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

#### Deployment

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

=> ./f3s-observability-tempo/grafana-tempo-trace.png Distributed trace visualization in Grafana Tempo showing Frontend → Middleware → Backend spans

For additional examples of Tempo trace visualization, see also:

=> https://foo.zone/gemfeed/2025-12-24-x-rag-observability-hackathon.html X-RAG Observability Hackathon (more Grafana Tempo screenshots)

The trace reveals the distributed request flow:
* **Frontend (221ms)**: Receives GET /api/process, executes business logic, calls middleware
* **Middleware (186ms)**: Receives POST /api/transform, transforms data, calls backend
* **Backend (104ms)**: Receives GET /api/data, simulates database query with 100ms sleep
* **Total request time**: 221ms end-to-end
* **Span propagation**: W3C Trace Context headers automatically link all spans

**6. Service graph visualization:**

The service graph is automatically generated from traces and shows service dependencies. For examples of service graph visualization in Grafana, see the screenshots in the X-RAG Observability Hackathon blog post.

=> https://foo.zone/gemfeed/2025-12-24-x-rag-observability-hackathon.html X-RAG Observability Hackathon (includes service graph screenshots)

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

### Complete Observability Stack

The f3s cluster now has complete observability:

**Metrics** (Prometheus):
* Cluster resource usage
* Application metrics
* Node metrics (FreeBSD ZFS, OpenBSD edge)
* etcd health

**Logs** (Loki):
* All pod logs
* Structured log collection
* Log aggregation and search

**Traces** (Tempo):
* Distributed request tracing
* Service dependency mapping
* Performance profiling
* Error tracking

**Visualization** (Grafana):
* Unified dashboards
* Correlation between metrics, logs, and traces
* Service graphs
* Alerts

### Configuration Files

All configuration files are available on Codeberg:

=> https://codeberg.org/snonux/conf/src/branch/master/f3s/tempo Tempo configuration
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/loki Alloy configuration (updated for traces)
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/tracing-demo Demo tracing application
