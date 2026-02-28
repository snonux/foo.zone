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

This time I want to share some themes that build on what we've already covered: how system design and incident analysis fit together, why observability should not be an afterthought, and how a design‑improvement loop keeps systems getting better. Let's dive in!

## Table of Contents

* [⇢ Site Reliability Engineering - Part 5: System Design, Incidents, and Learning](#site-reliability-engineering---part-5-system-design-incidents-and-learning)
* [⇢ ⇢ System Design and Incident Analysis](#system-design-and-incident-analysis)
* [⇢ ⇢ ⇢ Resilience and cascading failures](#resilience-and-cascading-failures)
* [⇢ ⇢ ⇢ Learning from incidents](#learning-from-incidents)
* [⇢ ⇢ Observability: Don't leave it for when it's too late](#observability-don-t-leave-it-for-when-it-s-too-late)
* [⇢ ⇢ The iterative spirit](#the-iterative-spirit)
* [⇢ ⇢ Book tips](#book-tips)

## System Design and Incident Analysis

A big chunk of SRE work revolves around system design and incident analysis. What separates a well-designed system from a mediocre one is its ability to minimise and contain cascading failures. Unchecked, those can spiral into global outages.

### Resilience and cascading failures

There's a growing emphasis on building resilient systems so that when something fails, the blast radius stays small. That resilience needs to be baked in at design time: we identify weak points and address them before production. The goal is to keep services dependable and uninterrupted.

### Learning from incidents

When incidents do happen, their analysis is a goldmine. Every incident exposes gaps—whether in tooling (ops tools that aren't up to the job) or in skills (engineers missing critical know-how). Blaming "human error" doesn't help. The job is to dig into root causes and fix the system. Postmortems that focus on customer impact help us distil lessons and make the system more robust so we're less likely to repeat the same failure.

System design and incident analysis form a feedback loop: we improve the design based on what we learn from incidents, and a better design reduces the impact of the next one.

## Observability: Don't leave it for when it's too late

Product and features often get the spotlight; observability is often an afterthought. Teams agree that "we need better observability" when they're already in the middle of an incident—and by then it's too late. Good observability needs to be in place before things go wrong. Tools that can query high-cardinality data and give granular insight into system behaviour are what let us diagnose problems quickly when chaos hits. So invest in observability early. When the next incident happens, you'll be glad you did.

## The iterative spirit

We also accept that system design is never "done." We refine it based on real-world performance, incident learnings, and changing needs. Every incident is a chance to learn and improve; the emphasis is on learning, not blame. SREs work with developers, backend teams, and incident response so that the whole system keeps getting better. Perfection is a journey, not a destination.

## Book tips

If you want to go deeper, here are a few books I can recommend:

* 97 Things Every SRE Should Know: Collective Wisdom from the Experts by Emily Stolarsky and Jaime Woo
* Site Reliability Engineering: How Google Runs Production Systems by Jennifer Petoff, Niall Murphy, Betsy Beyer, and Chris Jones
* Implementing Service Level Objectives by Alex Hidalgo

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
