# Site Reliability Engineering - Part 5: System Design, Incidents, and Learning

> Published at 2026-03-01T12:00:00+02:00

Welcome to Part 5 of my Site Reliability Engineering (SRE) series. I'm currently working as a Site Reliability Engineer, and I'm here to share what SRE is all about in this blog series.

<< template::inline::index site-reliability-engineering-part

```
    ___
   /   \     resilience
  |  o  |  <----------  learning
   \___/
```

This time I want to talk about how system design and incident analysis fit together, and why observability shouldn't be an afterthought.

<< template::inline::toc

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

=> ../ Back to the main site
