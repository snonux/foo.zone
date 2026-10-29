# Site Reliability Engineering - Part 5: System Design, Incidents, and Learning

> Published at 2026-03-01T12:00:00+02:00

Welcome to Part 5 of my Site Reliability Engineering (SRE) series. I'm currently working as a Site Reliability Engineer, and I'm here to share what SRE is all about in this blog series.

[2023-08-18 Site Reliability Engineering - Part 1: SRE and Organizational Culture](./2023-08-18-site-reliability-engineering-part-1.md)  
[2023-11-19 Site Reliability Engineering - Part 2: Operational Balance](./2023-11-19-site-reliability-engineering-part-2.md)  
[2024-01-09 Site Reliability Engineering - Part 3: On-Call Culture](./2024-01-09-site-reliability-engineering-part-3.md)  
[2024-09-07 Site Reliability Engineering - Part 4: Onboarding for On-Call Engineers](./2024-09-07-site-reliability-engineering-part-4.md)  
[2026-03-01 Site Reliability Engineering - Part 5: System Design, Incidents, and Learning (You are currently reading this)](./2026-03-01-site-reliability-engineering-part-5.md)  

```
    ___
   /   \     resilience
  |  o  |  <----------  learning
   \___/
```

This time I want to talk about how system design and incident analysis fit together, and why observability shouldn't be an afterthought.

## Table of Contents

* [⇢ Site Reliability Engineering - Part 5: System Design, Incidents, and Learning](#site-reliability-engineering---part-5-system-design-incidents-and-learning)
* [⇢ ⇢ System Design and Incident Analysis](#system-design-and-incident-analysis)
* [⇢ ⇢ ⇢ Resilience and cascading failures](#resilience-and-cascading-failures)
* [⇢ ⇢ ⇢ Learning from incidents](#learning-from-incidents)
* [⇢ ⇢ Observability: Don't leave it for when it's too late](#observability-don-t-leave-it-for-when-it-s-too-late)
* [⇢ ⇢ The iterative spirit](#the-iterative-spirit)
* [⇢ ⇢ Book tips](#book-tips)

## System Design and Incident Analysis

In my experience, a big chunk of SRE work revolves around system design and incident analysis. The big question is whether the system can contain cascading failures. If it can't, one bad component takes everything down.

### Resilience and cascading failures

Think about resilience at design time, not after the first outage. Find the weak points before production and keep the blast radius small for when something fails.

### Learning from incidents

When incidents happen, analyse them. Every incident exposes a gap, either in tooling or in skills. Don't blame "human error"; dig into the root causes and fix the system. Postmortems that focus on customer impact make it less likely we repeat the same failure.

## Observability: Don't leave it for when it's too late

Teams usually agree that "we need better observability" in the middle of an incident, when it's too late. Observability always loses against product features. But you need it in place before things go wrong: tools that can query high-cardinality data and tell you what is going on right now.

## The iterative spirit

System design is never "done." It gets refined based on real-world performance, incident learnings, and changing needs. SREs work with developers and incident response so that the whole system keeps improving.

## Book tips

If you want to go deeper, here are a few books I can recommend:

* 97 Things Every SRE Should Know: Collective Wisdom from the Experts by Emily Stolarsky and Jaime Woo
* Site Reliability Engineering: How Google Runs Production Systems by Jennifer Petoff, Niall Murphy, Betsy Beyer, and Chris Jones
* Implementing Service Level Objectives by Alex Hidalgo

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
