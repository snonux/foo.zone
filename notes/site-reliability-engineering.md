# "Site Reliability Engineering" book notes

These are my personal book notes of Niall Richard Murphy's "Site Reliability Engineering: How Google Runs Production systems". They are for myself, but I hope they might be useful to you too.

## Table of Contents

* [⇢ "Site Reliability Engineering" book notes](#site-reliability-engineering-book-notes)
* [⇢ ⇢ Key Concepts in SRE](#key-concepts-in-sre)
* [⇢ ⇢ ⇢ Role of an SRE:](#role-of-an-sre)
* [⇢ ⇢ ⇢ Error Budget](#error-budget)
* [⇢ ⇢ ⇢ On-call Management](#on-call-management)
* [⇢ ⇢ ⇢ Reliability Metrics](#reliability-metrics)
* [⇢ ⇢ ⇢ Service Indicators](#service-indicators)
* [⇢ ⇢ ⇢ Metrics and Error Rates](#metrics-and-error-rates)
* [⇢ ⇢ ⇢ Testing and Monitoring](#testing-and-monitoring)
* [⇢ ⇢ ⇢ Automation and Human Involvement](#automation-and-human-involvement)
* [⇢ ⇢ ⇢ SRE Work Distribution](#sre-work-distribution)
* [⇢ ⇢ ⇢ Post-mortem Practices](#post-mortem-practices)
* [⇢ ⇢ ⇢ Load Testing](#load-testing)
* [⇢ ⇢ ⇢ Criticality and Throttling](#criticality-and-throttling)
* [⇢ ⇢ ⇢ Toil Management](#toil-management)
* [⇢ ⇢ ⇢ Efficient Operations](#efficient-operations)

## Key Concepts in SRE

### Role of an SRE:

Ideally, SREs should spend no more than 50% of their time on operational work. The focus should primarily be on development activities. Systems should self-heal automatically.

### Error Budget

No development work should occur when the error budget is exceeded for a whole quarter, requiring strong management support. Error budgets help resolve conflicts between development and operational work by creating a common incentive, allowing both product development and SRE teams to balance innovation with reliability. Removes need for negotiations on the number of feature changes allowed.

### On-call Management

An on-call engineer should encounter a maximum of two events per eight hours to ensure sufficient time for cleanup and post-mortems. This allows thorough investigation and learning without overwhelming engineers. Monitoring should alert only when human interaction is required. Logs should be used for later forensics and not require immediate attention. Uptime is calculated with successful requests included, potentially by source, considering volume, partial writes, and HTTP response codes.

### Reliability Metrics

* Reliability is a function of Mean Time to Failure (MTTF) and Mean Time to Repair (MTTR).
* Playbooks can improve MTTR.
* Self-healing is optimal for operational efficiency.
* Capacity is a function of comprehensive capacity planning, critically viewed by SREs for performance improvements.

### Service Indicators

Choose an appropriate number of SLIs/KPIs to maintain focus without missing vital aspects of system performance. KPIs and SLIs are crucial for real-time metrics like uptime, latency, and throughput, often aggregated for analysis. Risk tolerance should be set in collaboration with product teams for user-facing services.

### Metrics and Error Rates

Accurate measurement involves considering all system components, including infrastructure error rates from networking, hardware, etc. High availability solutions (HA) and ISP background error rates can influence the impact of network outages on the error budget.

### Testing and Monitoring

Regular DR/Chaos testing is essential to gauge the impact of outages (like DC outages) on availability. Comprehensive testing ensures systems can handle variable loads without catastrophic failure. Monitoring and alert systems should swiftly address concerns, measuring latency on errors to distinguish 'slow' from 'fast' failures.

### Automation and Human Involvement

While automation can replace manual error resolution, maintaining human expertise is vital to operate systems when automation fails or becomes opaque over time.

### SRE Work Distribution

Google SREs, for example, allocate their work as 25% on-call, 25% non-urgent operations, and 50% engineering tasks.

### Post-mortem Practices

Creating post-mortems is a learning opportunity, not a punishment. They must be deliberate and not merely procedural. Post-mortems should be comprehensive to ensure lessons are applied effectively.

### Load Testing

 Proper load testing identifies when a system begins rejecting traffic and observes how it handles excess load. Systems should be tested at the subsystem level to identify different thresholds.

### Criticality and Throttling

Client-side rate limiting can implement adaptive throttling based on error counts. Systems should be designed to prioritize requests of higher criticality.

### Toil Management

Toil should account for less than 50% of an SRE's work currently and must be minimized. Toil is repetitive, manual work that could be automated. A balance must be struck, as occasional toil can prove insightful, but excessive toil detrimentally affects morale and productivity. Different engineers have varied thresholds for tolerating toil, influencing job satisfaction and retention.

### Efficient Operations

Toil, overhead, and non-operational tasks should be distinguished from core operational activities, which do not relate to direct HR or interview processes. Monitoring alerts should inform the necessary actions with clear context ("the what and the why") to minimize unnecessary manual efforts.

Other book notes of mine are:


E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
