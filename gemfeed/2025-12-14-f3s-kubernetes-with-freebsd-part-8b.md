# f3s: Kubernetes with FreeBSD - Part 8b: Distributed Tracing with Tempo

> Published at 2025-12-14T20:00:00+02:00

This is a follow-up to Part 8 of the f3s series, where I covered Prometheus, Grafana, Loki, and Alloy. Now it's time for the last pillar of observability: distributed tracing with Grafana Tempo.

[Part 8: Observability (Prometheus, Grafana, Loki, Alloy)](./2025-12-07-f3s-kubernetes-with-freebsd-part-8.md)  

For a preview of what distributed tracing with Tempo looks like in Grafana, check out the X-RAG blog post:

[X-RAG Observability Hackathon](./2025-12-24-x-rag-observability-hackathon.md)  

## Table of Contents

* [⇢ f3s: Kubernetes with FreeBSD - Part 8b: Distributed Tracing with Tempo](#f3s-kubernetes-with-freebsd---part-8b-distributed-tracing-with-tempo)
* [⇢ ⇢ Why Distributed Tracing?](#why-distributed-tracing)
* [⇢ ⇢ Deploying Grafana Tempo](#deploying-grafana-tempo)
* [⇢ ⇢ ⇢ Tempo Helm Values](#tempo-helm-values)
* [⇢ ⇢ ⇢ Persistent Volumes](#persistent-volumes)
* [⇢ ⇢ ⇢ Grafana Datasource Provisioning](#grafana-datasource-provisioning)
* [⇢ ⇢ ⇢ Installation](#installation)
* [⇢ ⇢ Configuring Alloy for Trace Collection](#configuring-alloy-for-trace-collection)
* [⇢ ⇢ Demo Tracing Application](#demo-tracing-application)
* [⇢ ⇢ ⇢ Architecture](#architecture)
* [⇢ ⇢ ⇢ OpenTelemetry Instrumentation](#opentelemetry-instrumentation)
* [⇢ ⇢ ⇢ Deployment](#deployment)
* [⇢ ⇢ Visualizing Traces in Grafana](#visualizing-traces-in-grafana)
* [⇢ ⇢ ⇢ Searching for Traces](#searching-for-traces)
* [⇢ ⇢ ⇢ Service Graph](#service-graph)
* [⇢ ⇢ Practical Example: End-to-End Trace](#practical-example-end-to-end-trace)
* [⇢ ⇢ Correlation Between Signals](#correlation-between-signals)
* [⇢ ⇢ Storage and Retention](#storage-and-retention)
* [⇢ ⇢ Configuration Files](#configuration-files)

## Why Distributed Tracing?

In a microservices setup, a single user request can hop through multiple services. Tracing gives you:

* Request tracking across service boundaries
* Performance bottleneck identification
* Service dependency visualization
* Correlation with logs and metrics

Without it, you're basically guessing where time gets spent.

## Deploying Grafana Tempo

Tempo runs in monolithic mode — all components in one process, same pattern as Loki's SingleBinary deployment. Keeps things simple for a home lab.

The setup:

* Filesystem backend using hostPath (10Gi at `/data/nfs/k3svolumes/tempo/data`)
* 7-day retention (168h)
* OTLP receivers on gRPC (4317) and HTTP (4318)
* Bind to `0.0.0.0` to avoid Tempo 2.7+ localhost-only binding issue

### Tempo Helm Values

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

### Persistent Volumes

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

### Grafana Datasource Provisioning

All Grafana datasources (Prometheus, Alertmanager, Loki, Tempo) are provisioned via a single ConfigMap mounted directly to the Grafana pod. No sidecar discovery needed.

In `grafana-datasources-all.yaml`:

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

The Tempo datasource config links traces to Loki logs and Prometheus metrics — so you can jump between signals directly in Grafana.

The kube-prometheus-stack Helm values disable sidecar-based discovery and mount this ConfigMap directly to `/etc/grafana/provisioning/datasources/`.

### Installation

```
cd /home/paul/git/conf/f3s/tempo
just install
```

Verify it's running:

```
kubectl get pods -n monitoring -l app.kubernetes.io/name=tempo
kubectl exec -n monitoring <tempo-pod> -- wget -qO- http://localhost:3200/ready
```

## Configuring Alloy for Trace Collection

I updated the Alloy values to add OTLP receivers for traces alongside the existing log collection.

Added to the Alloy config:

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

// Batch processor — accumulates spans before forwarding to Tempo
otelcol.processor.batch "default" {
  timeout = "5s"
  send_batch_size = 100
  send_batch_max_size = 200
  output {
    traces = [otelcol.exporter.otlp.tempo.input]
  }
}

// OTLP exporter to Tempo
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

Upgrade Alloy:

```
cd /home/paul/git/conf/f3s/loki
just upgrade
```

## Demo Tracing Application

To actually see traces, I built a three-tier Python app. Nothing fancy — just enough to generate real distributed traces.

### Architecture

```
User -> Frontend (Flask:5000) -> Middleware (Flask:5001) -> Backend (Flask:5002)
           |                          |                        |
                    Alloy (OTLP:4317) -> Tempo -> Grafana
```

* Frontend: receives requests at `/api/process`, forwards to middleware
* Middleware: transforms data at `/api/transform`, calls backend
* Backend: returns data at `/api/data`, simulates a 100ms database query

### OpenTelemetry Instrumentation

All three services use Python OpenTelemetry libraries:

Dependencies:

```
flask==3.0.0
requests==2.31.0
opentelemetry-distro==0.49b0
opentelemetry-exporter-otlp==1.28.0
opentelemetry-instrumentation-flask==0.49b0
opentelemetry-instrumentation-requests==0.49b0
```

Auto-instrumentation pattern (same across all services, just change the service name):

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor
from opentelemetry.sdk.resources import Resource

resource = Resource(attributes={
    "service.name": "frontend",
    "service.namespace": "tracing-demo",
    "service.version": "1.0.0"
})

provider = TracerProvider(resource=resource)

otlp_exporter = OTLPSpanExporter(
    endpoint="http://alloy.monitoring.svc.cluster.local:4317",
    insecure=True
)

processor = BatchSpanProcessor(otlp_exporter)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()
```

The auto-instrumentation creates spans for HTTP requests, propagates trace context via W3C headers, and links parent/child spans across services automatically.

### Deployment

The demo app has a Helm chart in the conf repo. Build, import the container images, and install:

```
cd /home/paul/git/conf/f3s/tracing-demo
just build
just import
just install
```

Verify:

```
kubectl get pods -n services | grep tracing-demo
kubectl get ingress -n services tracing-demo-ingress
```

Access at:

[http://tracing-demo.f3s.foo.zone](http://tracing-demo.f3s.foo.zone)  

## Visualizing Traces in Grafana

### Searching for Traces

In Grafana, go to Explore, select the Tempo datasource, and you can search by trace ID, service name, or tags.

Some useful TraceQL queries:

Find all traces from the demo app:
```
{ resource.service.namespace = "tracing-demo" }
```

Find slow requests (>200ms):
```
{ duration > 200ms }
```

Find traces from a specific service:
```
{ resource.service.name = "frontend" }
```

Find errors:
```
{ status = error }
```

Frontend traces with server errors:
```
{ resource.service.namespace = "tracing-demo" } && { span.http.status_code >= 500 }
```

### Service Graph

The service graph view shows visual connections between services — Frontend to Middleware to Backend — with request rates and latencies. It's generated automatically from trace data using Prometheus metrics.

## Practical Example: End-to-End Trace

Here's what it looks like to generate and examine a trace.

Generate a trace:

```
curl -H "Host: tracing-demo.f3s.foo.zone" http://r0/api/process
```

Response (HTTP 200):

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

After a few seconds (batch export delay), search for traces via Tempo API:

```
kubectl exec -n monitoring tempo-0 -- wget -qO- \
  'http://localhost:3200/api/search?tags=service.namespace%3Dtracing-demo&limit=5' 2>/dev/null | \
  python3 -m json.tool
```

Returns something like:

```json
{
  "traceID": "4be1151c0bdcd5625ac7e02b98d95bd5",
  "rootServiceName": "frontend",
  "rootTraceName": "GET /api/process",
  "durationMs": 221
}
```

The full trace has 8 spans across 3 services:

```
Trace ID: 4be1151c0bdcd5625ac7e02b98d95bd5

Service: frontend
  GET /api/process                 221.10ms  (HTTP server span)
  frontend-process                 216.23ms  (business logic)
  POST                             209.97ms  (HTTP client -> middleware)

Service: middleware
  POST /api/transform              186.02ms  (HTTP server span)
  middleware-transform             180.96ms  (business logic)
  GET                              127.52ms  (HTTP client -> backend)

Service: backend
  GET /api/data                    103.93ms  (HTTP server span)
  backend-get-data                 102.11ms  (business logic, 100ms sleep)
```

In Grafana, paste the trace ID in the Tempo search box or use TraceQL:

```
{ resource.service.namespace = "tracing-demo" }
```

The waterfall view shows the complete request flow with timing:

[![Distributed trace in Grafana Tempo: Frontend -> Middleware -> Backend](./f3s-kubernetes-with-freebsd-part-8/grafana-tempo-trace.png "Distributed trace in Grafana Tempo: Frontend -> Middleware -> Backend")](./f3s-kubernetes-with-freebsd-part-8/grafana-tempo-trace.png)  

More Tempo trace screenshots in the X-RAG blog post:

[X-RAG Observability Hackathon](https://foo.zone/gemfeed/2025-12-24-x-rag-observability-hackathon.html)  

## Correlation Between Signals

This is where the observability stack really comes together. Tempo integrates with Loki and Prometheus so you can jump between traces, logs, and metrics.

Traces to logs: click on any span and select "Logs for this span." Loki filters by time range, service name, namespace, and pod. Super useful for figuring out what a service was doing during a specific request.

Traces to metrics: from a trace view, the "Metrics" tab shows Prometheus data like request rate, error rate, and duration percentiles for the services involved.

Logs to traces: in Loki, logs containing trace IDs are automatically linked. Click the trace ID and you jump straight to the full trace in Tempo.

## Storage and Retention

With 10Gi storage and 7-day retention, the system handles moderate trace volumes. Check usage:

```
kubectl exec -n monitoring <tempo-pod> -- df -h /var/tempo
```

If storage fills up, you can reduce retention to 72h, add sampling in Alloy, or increase the PV size.

## Configuration Files

All config files are on Codeberg:

[Tempo configuration](https://codeberg.org/snonux/conf/src/branch/master/f3s/tempo)  
[Alloy configuration (updated for traces)](https://codeberg.org/snonux/conf/src/branch/master/f3s/loki)  
[Demo tracing application](https://codeberg.org/snonux/conf/src/branch/master/f3s/tracing-demo)  

Other *BSD-related posts:

[2026-04-02 f3s: Kubernetes with FreeBSD - Part 9: GitOps with ArgoCD](./2026-04-02-f3s-kubernetes-with-freebsd-part-9.md)  
[2025-12-14 f3s: Kubernetes with FreeBSD - Part 8b: Distributed Tracing with Tempo (You are currently reading this)](./2025-12-14-f3s-kubernetes-with-freebsd-part-8b.md)  
[2025-12-07 f3s: Kubernetes with FreeBSD - Part 8: Observability](./2025-12-07-f3s-kubernetes-with-freebsd-part-8.md)  
[2025-10-02 f3s: Kubernetes with FreeBSD - Part 7: k3s and first pod deployments](./2025-10-02-f3s-kubernetes-with-freebsd-part-7.md)  
[2025-07-14 f3s: Kubernetes with FreeBSD - Part 6: Storage](./2025-07-14-f3s-kubernetes-with-freebsd-part-6.md)  
[2025-05-11 f3s: Kubernetes with FreeBSD - Part 5: WireGuard mesh network](./2025-05-11-f3s-kubernetes-with-freebsd-part-5.md)  
[2025-04-05 f3s: Kubernetes with FreeBSD - Part 4: Rocky Linux Bhyve VMs](./2025-04-05-f3s-kubernetes-with-freebsd-part-4.md)  
[2025-02-01 f3s: Kubernetes with FreeBSD - Part 3: Protecting from power cuts](./2025-02-01-f3s-kubernetes-with-freebsd-part-3.md)  
[2024-12-03 f3s: Kubernetes with FreeBSD - Part 2: Hardware and base installation](./2024-12-03-f3s-kubernetes-with-freebsd-part-2.md)  
[2024-11-17 f3s: Kubernetes with FreeBSD - Part 1: Setting the stage](./2024-11-17-f3s-kubernetes-with-freebsd-part-1.md)  
[2024-04-01 KISS high-availability with OpenBSD](./2024-04-01-KISS-high-availability-with-OpenBSD.md)  
[2024-01-13 One reason why I love OpenBSD](./2024-01-13-one-reason-why-i-love-openbsd.md)  
[2022-10-30 Installing DTail on OpenBSD](./2022-10-30-installing-dtail-on-openbsd.md)  
[2022-07-30 Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  
[2016-04-09 Jails and ZFS with Puppet on FreeBSD](./2016-04-09-jails-and-zfs-on-freebsd-with-puppet.md)  

E-Mail your comments to `paul@nospam.buetow.org`

[Back to the main site](../)  
