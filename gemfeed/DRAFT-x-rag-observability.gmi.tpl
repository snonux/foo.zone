# X-RAG: A Journey from Blind to Enlightened

> Published at DRAFT

This blog post describes my journey adding observability to X-RAG, a distributed Retrieval-Augmented Generation (RAG) platform built by my brother Florian. I joined a 3-day hackathon (attending 2 days) with the goal of instrumenting his existing distributed system with proper observability. What started as "let's add some metrics" turned into a comprehensive implementation of the three pillars of observability: tracing, metrics, and logs.

=> https://github.com/florianbuetow/x-rag X-RAG source code on GitHub

<< template::inline::toc

## What is X-RAG?

X-RAG is a production-grade distributed RAG platform running on Kubernetes. It consists of several independently scalable microservices:

* Search UI: FastAPI web interface for queries
* Ingestion API: Document upload endpoint
* Embedding Service: gRPC service for vector embeddings
* Indexer: Kafka consumer that processes documents
* Search Service: gRPC service orchestrating the RAG pipeline

The data layer includes Weaviate (vector database with hybrid search), Kafka (message queue), MinIO (object storage), and Redis (cache). All of this runs in a Kind Kubernetes cluster for local development, with the same manifests deployable to production.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      X-RAG Kubernetes Cluster                            │
├─────────────────────────────────────────────────────────────────────────┤
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│   │ Search UI   │  │Search Svc   │  │Embed Service│  │   Indexer   │    │
│   └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘    │
│          │                │                │                │           │
│          └────────────────┴────────────────┴────────────────┘           │
│                                    │                                     │
│                                    ▼                                     │
│          ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│          │  Weaviate   │  │   Kafka     │  │   MinIO     │              │
│          └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────────────┘
```

## The problem: flying blind

When I joined the hackathon, Florian's X-RAG was functional but opaque. With five services communicating via gRPC, Kafka, and HTTP, debugging was painful. When a search request took 5 seconds instead of the expected 500 milliseconds, there was no visibility into where the time was being spent. Was it the embedding generation? The vector search? The LLM synthesis? Nobody knew.

Distributed systems are inherently opaque. Each service logs its own view of the world, but correlating events across service boundaries is archaeology. Grepping through logs on five different pods, trying to mentally reconstruct what happened—not fun. This was the perfect hackathon project: a real problem with tangible results.

## Step 1: centralised logging with Loki

The first step was getting all logs in one place. I deployed Grafana Loki in the monitoring namespace, with Grafana Alloy running as a DaemonSet on each node to collect logs.

```
┌──────────────────────────────────────────────────────────────────────┐
│                           LOGS PIPELINE                               │
├──────────────────────────────────────────────────────────────────────┤
│  Applications write to stdout → containerd stores in /var/log/pods   │
│                                    │                                  │
│                              File tail                                │
│                                    ▼                                  │
│                         Grafana Alloy (DaemonSet)                     │
│                    Discovers pods, extracts metadata                  │
│                                    │                                  │
│                       HTTP POST /loki/api/v1/push                     │
│                                    ▼                                  │
│                           Grafana Loki                                │
│                   Indexes labels, stores chunks                       │
└──────────────────────────────────────────────────────────────────────┘
```

Alloy's configuration uses River language to discover Kubernetes pods and add labels:

```
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

Now I could query logs with LogQL:

```
{namespace="rag-system", container="search-ui"} |= "ERROR"
```

=> ./x-rag-observability/loki-explore.png Exploring logs in Grafana with Loki

But there was a problem: logs lacked correlation. I could see that an error occurred in the indexer, but I couldn't trace it back to the specific ingestion request that triggered it.

## Step 2: metrics with Prometheus

Next, I added Prometheus metrics to every service. Following the Four Golden Signals (latency, traffic, errors, saturation), I instrumented the codebase with histograms, counters, and gauges:

```python
from prometheus_client import Histogram, Counter, Gauge

search_duration = Histogram(
    "search_service_request_duration_seconds",
    "Total duration of Search Service requests",
    ["method"],
    buckets=[0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0, 20.0, 30.0, 60.0],
)

errors_total = Counter(
    "search_service_errors_total",
    "Error count by type",
    ["method", "error_type"],
)
```

Initially, I used Prometheus scraping—each service exposed a /metrics endpoint, and Prometheus pulled metrics every 15 seconds. This worked, but I wanted a unified pipeline.

The breakthrough came with Grafana Alloy as an OpenTelemetry collector. Services now push metrics via OTLP (OpenTelemetry Protocol), and Alloy converts them to Prometheus format:

```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ search-ui   │  │search-svc   │  │embed-svc    │  │  indexer    │
│ OTel Meter  │  │ OTel Meter  │  │ OTel Meter  │  │ OTel Meter  │
│      │      │  │      │      │  │      │      │  │      │      │
│ OTLPExporter│  │ OTLPExporter│  │ OTLPExporter│  │ OTLPExporter│
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       │                │                │                │
       └────────────────┴────────────────┴────────────────┘
                                 │
                                 ▼ OTLP/gRPC (port 4317)
                        ┌─────────────────────┐
                        │   Grafana Alloy     │
                        └──────────┬──────────┘
                                   │ prometheus.remote_write
                                   ▼
                        ┌─────────────────────┐
                        │    Prometheus       │
                        └─────────────────────┘
```

With Grafana dashboards, I could now see latency percentiles, throughput, and error rates.

=> ./x-rag-observability/prometheus-metrics.png Prometheus metrics in Grafana

But metrics told me *that* something was wrong—they didn't tell me *where* in the request path the problem occurred.

## Step 3: the breakthrough—distributed tracing

The real enlightenment came with OpenTelemetry tracing. I integrated auto-instrumentation for FastAPI, gRPC, and HTTP clients, plus manual spans for RAG-specific operations:

```python
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.grpc import GrpcAioInstrumentorClient

# Auto-instrument frameworks
FastAPIInstrumentor.instrument_app(app)
GrpcAioInstrumentorClient().instrument()

# Manual spans for custom operations
with tracer.start_as_current_span("llm.rag_completion") as span:
    span.set_attribute("llm.model", model_name)
    result = await generate_answer(query, context)
```

The magic is trace context propagation. When the Search UI calls the Search Service via gRPC, the trace ID travels in metadata headers:

```
Metadata: [
  ("traceparent", "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01"),
  ("content-type", "application/grpc"),
]
```

Spans from all services are linked by this trace ID, forming a tree:

```
Trace ID: 0af7651916cd43dd8448eb211c80319c

├─ [search-ui] POST /api/search (300ms)
│   │
│   ├─ [search-service] Search (gRPC server) (275ms)
│   │   │
│   │   ├─ [search-service] embedding.generate (50ms)
│   │   │   └─ [embedding-service] Embed (45ms)
│   │   │       └─ POST https://api.openai.com (35ms)
│   │   │
│   │   ├─ [search-service] vector_search.query (100ms)
│   │   │
│   │   └─ [search-service] llm.rag_completion (120ms)
│           └─ openai.chat (115ms)
```

Traces are collected by Alloy and stored in Grafana Tempo. In Tempo's UI, I can finally see exactly where time is spent. That 5-second query? Turns out the vector search was waiting on a cold Weaviate connection. Now I knew what to fix.

=> ./x-rag-observability/tempo-trace.png Visualising a trace in Grafana Tempo

=> ./x-rag-observability/tempo-trace-detail.png Trace detail showing span attributes

## Infrastructure metrics: Kafka, Redis, MinIO

Application metrics weren't enough. I also needed visibility into the data layer. Each infrastructure component got its own exporter:

* Redis: oliver006/redis_exporter as a sidecar, exposing cache hit rates, memory usage, and client connections
* Kafka: danielqsj/kafka-exporter as a standalone deployment, tracking consumer lag, partition offsets, and broker health
* MinIO: Native /minio/v2/metrics/cluster endpoint for S3 request rates, error counts, and disk usage

Alloy scrapes all of these and remote-writes to Prometheus:

```
prometheus.scrape "redis_exporter" {
  targets = [{"__address__" = "xrag-redis:9121"}]
  forward_to = [prometheus.remote_write.prom.receiver]
}
```

Now I can query Kafka consumer lag to see if the indexer is falling behind:

```promql
sum by (consumergroup, topic) (kafka_consumergroup_lag)
```

Or check Redis cache effectiveness:

```promql
redis_keyspace_hits_total / (redis_keyspace_hits_total + redis_keyspace_misses_total)
```

=> ./x-rag-observability/infrastructure-dashboard.png Infrastructure metrics dashboard

## Async ingestion trace walkthrough

One of the most powerful aspects of distributed tracing is following requests across async boundaries like message queues. The document ingestion pipeline flows through Kafka, creating spans that are linked even though they execute in different processes at different times.

### Step 1: Ingest a document

```
$ curl -s -X POST http://localhost:8082/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "text": "This is the X-RAG Observability Guide...",
    "metadata": {
      "title": "X-RAG Observability Guide",
      "source_file": "docs/OBSERVABILITY.md",
      "type": "markdown"
    },
    "namespace": "default"
  }' | jq .
{
  "document_id": "8538656a-ba99-406c-8da7-87c5f0dda34d",
  "status": "accepted",
  "minio_bucket": "documents",
  "minio_key": "8538656a-ba99-406c-8da7-87c5f0dda34d.json",
  "message": "Document accepted for processing"
}
```

The ingestion API immediately returns—it doesn't wait for indexing. The document is stored in MinIO and a message is published to Kafka.

### Step 2: Find the ingestion trace

```
$ curl -s -G "http://localhost:3200/api/search" \
  --data-urlencode 'q={name="POST /ingest"}' \
  --data-urlencode 'limit=3' | jq '.traces[0].traceID'
"b3fc896a1cf32b425b8e8c46c86c76f7"
```

### Step 3: Fetch the complete trace

```
$ curl -s "http://localhost:3200/api/traces/b3fc896a1cf32b425b8e8c46c86c76f7" \
  | jq '[.batches[] | ... | {service, span}] | unique'
[
  { "service": "ingestion-api", "span": "POST /ingest" },
  { "service": "ingestion-api", "span": "storage.upload" },
  { "service": "ingestion-api", "span": "messaging.publish" },
  { "service": "indexer", "span": "indexer.process_document" },
  { "service": "indexer", "span": "document.duplicate_check" },
  { "service": "indexer", "span": "document.pipeline" },
  { "service": "indexer", "span": "storage.download" },
  { "service": "indexer", "span": "/xrag.embedding.EmbeddingService/EmbedBatch" },
  { "service": "embedding-service", "span": "openai.embeddings" },
  { "service": "indexer", "span": "db.insert" }
]
```

The trace spans **three services**: ingestion-api, indexer, and embedding-service. The trace context propagates through Kafka, linking the original HTTP request to the async consumer processing.

### Step 4: Analyse the async trace

```
ingestion-api | POST /ingest             |   16ms  ← HTTP response returns
ingestion-api | storage.upload           |   13ms  ← Save to MinIO
ingestion-api | messaging.publish        |    1ms  ← Publish to Kafka
              |                          |         
              | ~~~ Kafka queue ~~~      |         ← Async boundary
              |                          |         
indexer       | indexer.process_document | 1799ms  ← Consumer picks up message
indexer       | document.duplicate_check |    1ms
indexer       | document.pipeline        | 1796ms
indexer       | storage.download         |    1ms  ← Fetch from MinIO
indexer       | EmbedBatch (gRPC)        |  754ms  ← Call embedding service
embedding-svc | openai.embeddings        |  752ms  ← OpenAI API
indexer       | db.insert                | 1038ms  ← Store in Weaviate
```

The total async processing takes ~1.8 seconds, but the user sees a 16ms response. Without tracing, debugging "why isn't my document showing up in search results?" would require correlating logs from three services manually.

**Key insight**: The trace context propagates through Kafka message headers, allowing the indexer's spans to link back to the original ingestion request. This is configured via OpenTelemetry's Kafka instrumentation.

### Viewing traces in Grafana

To view a trace in Grafana's UI:

1. Open Grafana at http://localhost:3000/explore
2. Select **Tempo** as the data source (top-left dropdown)
3. Choose **TraceQL** as the query type
4. Paste the trace ID: `b3fc896a1cf32b425b8e8c46c86c76f7`
5. Click **Run query**

The trace viewer shows a Gantt chart with all spans, their timing, and parent-child relationships. Click any span to see its attributes.

=> ./x-rag-observability/index-trace.png Async ingestion trace in Grafana Tempo

=> ./x-rag-observability/index-node-graph.png Ingestion trace node graph showing service dependencies

## End-to-end search trace walkthrough

To demonstrate the observability stack in action, here's a complete trace from a search request through all services.

### Step 1: Make a search request

```
$ curl -s -X POST http://localhost:8080/api/search \
  -H "Content-Type: application/json" \
  -d '{"query": "What is RAG?", "namespace": "default", "mode": "hybrid", "top_k": 5}' | jq .
{
  "answer": "I don't have enough information to answer this question.",
  "sources": [
    {
      "id": "71adbc34-56c1-4f75-9248-4ed38094ac69",
      "content": "# X-RAG Observability Guide This document describes...",
      "score": 0.8292956352233887,
      "metadata": {
        "source": "docs/OBSERVABILITY.md",
        "type": "markdown",
        "namespace": "default"
      }
    }
  ],
  "metadata": {
    "namespace": "default",
    "num_sources": "5",
    "cache_hit": "False",
    "mode": "hybrid",
    "top_k": "5",
    "trace_id": "9df981cac91857b228eca42b501c98c6"
  }
}
```

The response includes a `trace_id` that links this request to all spans across services.

### Step 2: Query Tempo for the trace

Using the trace ID from the response, query Tempo's API:

```
$ curl -s "http://localhost:3200/api/traces/9df981cac91857b228eca42b501c98c6" \
  | jq '.batches[].scopeSpans[].spans[] 
        | {name, service: .attributes[] 
           | select(.key=="service.name") 
           | .value.stringValue}'
```

The raw trace shows spans from multiple services:

* **search-ui**: `POST /api/search` (root span, 2138ms total)
* **search-ui**: `/xrag.search.SearchService/Search` (gRPC client call)
* **search-service**: `/xrag.search.SearchService/Search` (gRPC server)
* **search-service**: `/xrag.embedding.EmbeddingService/Embed` (gRPC client)
* **embedding-service**: `/xrag.embedding.EmbeddingService/Embed` (gRPC server)
* **embedding-service**: `openai.embeddings` (OpenAI API call, 647ms)
* **embedding-service**: `POST https://api.openai.com/v1/embeddings` (HTTP client)
* **search-service**: `vector_search.query` (Weaviate hybrid search, 13ms)
* **search-service**: `openai.chat` (LLM answer generation, 1468ms)
* **search-service**: `POST https://api.openai.com/v1/chat/completions` (HTTP client)

### Step 3: Analyse the trace

From this single trace, I can see exactly where time is spent:

```
Total request:                     2138ms
├── gRPC to search-service:        2135ms
│   ├── Embedding generation:       649ms
│   │   └── OpenAI embeddings API:   640ms
│   ├── Vector search (Weaviate):    13ms
│   └── LLM answer generation:     1468ms
│       └── OpenAI chat API:       1463ms
```

The bottleneck is clear: **68% of time is spent in LLM answer generation**. The vector search (13ms) and embedding generation (649ms) are relatively fast. Without tracing, I would have guessed the embedding service was slow—traces proved otherwise.

### Step 4: Search traces with TraceQL

Tempo supports TraceQL for querying traces by attributes:

```
$ curl -s -G "http://localhost:3200/api/search" \
  --data-urlencode 'q={resource.service.name="search-service"}' \
  --data-urlencode 'limit=5' | jq '.traces[:2] | .[].rootTraceName'
"/xrag.search.SearchService/Search"
"GET /health/ready"
```

Other useful TraceQL queries:

```
# Find slow searches (> 2 seconds)
{resource.service.name="search-ui" && name="POST /api/search"} | duration > 2s

# Find errors
{status=error}

# Find OpenAI calls
{name=~"openai.*"}
```

### Viewing the search trace in Grafana

Follow the same steps as above, but use the search trace ID: `9df981cac91857b228eca42b501c98c6`

=> ./x-rag-observability/search-trace.png Search trace in Grafana Tempo

=> ./x-rag-observability/search-node-graph.png Search trace node graph showing service flow

## Correlating the three signals

The real power comes from correlating traces, metrics, and logs. When an alert fires for high error rate, I follow this workflow:

1. Metrics: Prometheus shows error spike started at 10:23:00
2. Traces: Query Tempo for traces with status=error around that time
3. Logs: Use the trace ID to find detailed error messages in Loki

```
{namespace="rag-system"} |= "trace_id=abc123" |= "error"
```

Prometheus exemplars link specific metric samples to trace IDs, so I can click directly from a latency spike to the responsible trace.

=> ./x-rag-observability/signal-correlation.png Correlating metrics, traces, and logs in Grafana

## The observability stack

The complete stack runs in the monitoring namespace:

```
$ kubectl get pods -n monitoring
NAME                                  READY   STATUS
alloy-84ddf4cd8c-7phjp                1/1     Running
grafana-6fcc89b4d6-pnh8l              1/1     Running
kube-state-metrics-5d954c569f-2r45n   1/1     Running
loki-8c9bbf744-sc2p5                  1/1     Running
node-exporter-kb8zz                   1/1     Running
node-exporter-zcrdz                   1/1     Running
node-exporter-zmskc                   1/1     Running
prometheus-7f755f675-dqcht            1/1     Running
tempo-55df7dbcdd-t8fg9                1/1     Running
```

Everything is accessible via port-forwards or NodePort:

* Grafana: http://localhost:3000 (unified UI for all three signals)
* Prometheus: http://localhost:9090 (metrics queries)
* Tempo: http://localhost:3200 (trace queries)
* Loki: http://localhost:3100 (log queries)

## Results: two days well spent

What did two days of hackathon work achieve? The system went from flying blind to fully instrumented:

* All three pillars implemented: logs (Loki), metrics (Prometheus), traces (Tempo)
* Unified collection via Grafana Alloy
* Infrastructure metrics for Kafka, Redis, and MinIO
* Grafana dashboards with PromQL queries
* Trace context propagation across all gRPC calls

The biggest insight from testing? The embedding service wasn't the bottleneck I assumed. Traces revealed that LLM synthesis (120ms average) dominated latency, not embedding generation (45ms). Without tracing, optimisation efforts would have targeted the wrong component.

## What's next

The system is now "enlightened," but there's always more:

* Semantic monitoring: Using LLM evaluation as a metric (relevance scores, hallucination detection)
* Alerting rules: Prometheus alerts for SLO violations
* Sampling strategies: For high-traffic production, sample traces to reduce storage costs

## Lessons learned

* Start with metrics, but don't stop there—they tell you *what*, not *why*
* Trace context propagation is the key to distributed debugging
* Grafana Alloy as a unified collector simplifies the pipeline
* Infrastructure metrics matter—your app is only as fast as your data layer
* The three pillars work together; none is sufficient alone

All manifests and observability code live in Florian's repository:

=> https://github.com/florianbuetow/x-rag X-RAG on GitHub (source code, K8s manifests, observability configs)

The observability-specific files I added during the hackathon:

* `infra/k8s/monitoring/` — Kubernetes manifests for Prometheus, Grafana, Tempo, Loki, Alloy
* `src/common/tracing.py` — OpenTelemetry TracerProvider initialisation
* `src/common/tracing_utils.py` — Manual span context managers
* `src/common/metrics.py` — Prometheus metric utilities
* `src/*/metrics.py` — Per-service metric definitions
* `docs/OBSERVABILITY.md` — Comprehensive observability guide

E-Mail your comments to paul@nospam.buetow.org

=> ../ Back to the main site
